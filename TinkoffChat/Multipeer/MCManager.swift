// Copyright 2016-2017, Ralf Ebert
// License   https://opensource.org/licenses/MIT
// Source    https://www.ralfebert.de/tutorials/ios-swift-multipeer-connectivity/

import Foundation
import MultipeerConnectivity

protocol ColorServiceManagerDelegate {
    
    func connectedDevicesChanged(manager : MCServiceManager, connectedDevices: [String])
    func colorChanged(manager : MCServiceManager, colorString: String)
    
}

class MCServiceManager : NSObject {
    
    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    private let ColorServiceType = "tinkoff-chat"
    
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser
    
    var delegate : ColorServiceManagerDelegate?
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: ["userName" : "mbabaev"], serviceType: ColorServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: ColorServiceType)
        
        super.init()
        
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    func generateMessageId() -> String {
        return "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)".data(using: .utf8)!.base64EncodedString()
    }
    
    func send(colorName : String) {
        NSLog("%@", "sendColor: \(colorName) to \(session.connectedPeers.count) peers")
        
        for peerID in session.connectedPeers {
            if peerID.displayName == "1862910D-5163-4E16-B94E-31F7CF34E3FA" {
                let message = MCMessage(eventType: "TextMessage", messageId: generateMessageId(), text: "Hello from babaev")
                
                do {
                    let json =  try JSONEncoder().encode(message)
                    try self.session.send(json, toPeers: [peerID], with: .reliable)
                } catch let error {
                    
                    print("ERRRRRRR")
                    print(error.localizedDescription)
                }
            }
        }
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(colorName.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
        
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
}

extension MCServiceManager : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        if peerID.displayName == "1862910D-5163-4E16-B94E-31F7CF34E3FA" {
            invitationHandler(true, self.session)
        }
    }
    
}

extension MCServiceManager : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        
        if peerID.displayName == "1862910D-5163-4E16-B94E-31F7CF34E3FA" {
            NSLog("%@", "foundPeer: \(peerID)")
            NSLog("%@", "invitePeer: \(peerID)")
            
            browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }
    
}

extension MCServiceManager : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if peerID.displayName != "1862910D-5163-4E16-B94E-31F7CF34E3FA" {
            return
        }
        
        
        NSLog("%@", "peer \(peerID) didChangeState: \(state)")
        self.delegate?.connectedDevicesChanged(manager: self, connectedDevices:
            session.connectedPeers.map{$0.displayName})
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        let str = String(data: data, encoding: .utf8)!
        print(str)
        
        let message = try? JSONDecoder().decode(MCMessage.self, from: data)
        print(message)
        print("finish")
        
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
    
}
