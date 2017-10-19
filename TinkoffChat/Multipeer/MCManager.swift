//
//  MCManager.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 18.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol MCManagerDelegate {
    func greet(username: String)
}

class MCManager: NSObject {
    static let shared = MCManager()
    
    let currentUserName = "mbabaev"
    let currentUserNameData = Data(base64Encoded: "mbabaev")
    
    var appServiceType = "tinkoff-chat"
    var session: MCSession!
    var devicePeerId: MCPeerID!
    var browser: MCNearbyServiceBrowser!
    var advertiser: MCNearbyServiceAdvertiser!
    
    var invitationHandler: ((Bool, MCSession) -> Void)!
    
    var delegate: MCManagerDelegate?
    
    var foundPeers = [MCPeerID]()
    
    
    var target: MCPeerID!
    
    override init() {
        
        super.init()
        
        devicePeerId = MCPeerID(displayName: UIDevice.current.name)
        
        session = MCSession(peer: devicePeerId)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: devicePeerId, serviceType: appServiceType)
        browser.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: devicePeerId, discoveryInfo: ["userName" : currentUserName], serviceType: appServiceType)
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
    }
}

extension MCManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print(peerID.displayName)
        print(state)
        
        print()
        
        if target != nil && target == peerID {
            let message = MCMessage(eventType: "TextMessage", messageId: "asdadasdasdasda", text: "Hello from babaev")
            
            do {
                let json =  try JSONEncoder().encode(message)
                try self.session.send(json, toPeers: [peerID], with: .reliable)
            } catch {
                print("ERRRRRRR")
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let message = String(data: data, encoding: .utf8)!
        print("receive data from peer: \(peerID.displayName) data: \(message)")
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        //
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        //
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        //
    }
    
    
}

extension MCManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("MC LOG: found peer: \(peerID.displayName)")
        
        foundPeers.append(peerID)
        
        let username = info?["userName"] ?? ""
        if username == "a.v.kiselev" {
             browser.invitePeer(peerID, to: self.session, withContext: currentUserNameData, timeout: 20)
            
             target = peerID
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        //
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        //
    }
}

extension MCManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
    
    
}







