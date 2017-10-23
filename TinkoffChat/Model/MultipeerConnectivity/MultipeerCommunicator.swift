//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 23.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerCommunicator: NSObject, Communicator {
    
    var delegate: CommunicatorDelegate?
    
    var online: Bool = false
    
    private let serviceType = "tinkoff-chat"
    
    //private var usersDict: [String : User] = [:]
    private var sessionsDict: [String : MCChatSession] = [:]
    private var foundedPeers: [MCPeerID] = []
    
    private let peer = MCPeerID(displayName: User.current.id)
    
    private let browser: MCNearbyServiceBrowser
    private let advertiser: MCNearbyServiceAdvertiser
    
    
    
    override init() {
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceType)
        
        let info = ["userName": User.current.name]
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: info, serviceType: serviceType)
        
        browser.startBrowsingForPeers()
        advertiser.startAdvertisingPeer()
        
        super.init()
        
        browser.delegate = self
        advertiser.delegate = self
    }
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        let message = Message(text: string)
        if let session = sessionsDict[userID] {
                
            do {
                let data = try JSONEncoder().encode(message)
                try session.send(data, toPeers: [session.targetPeer], with: .reliable)
                completionHandler?(true, nil)
            } catch {
                print("Send message error \(error.localizedDescription)")
                completionHandler?(false, error)
            }
        }
        
        completionHandler?(false, nil)
    }
    
    func invite(userID: String) {
        let session = sessionsDict[userID]!
        
        for peer in foundedPeers {
            if peer.displayName == userID {
                browser.invitePeer(peer, to: session, withContext: nil, timeout: 20)
            }
        }
    }
}

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if let username = info?["userName"] {
            foundedPeers.append(peerID)
            
            let id = peerID.displayName
            
            let session = MCChatSession(peer: self.peer, targetPeer: peerID)
            session.delegate = self
            sessionsDict[id] = session
            
            delegate?.didFoundUser(userID: id, userName: username)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        delegate?.didLostUser(userID: peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("didNotStartBrowsingForPeers error: \(error.localizedDescription)")
    }
}

extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("didNotStartAdvertisingPeer error: \(error.localizedDescription)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        let userId = peerID.displayName
        let session = MCChatSession(peer: self.peer, targetPeer: peerID)
        session.delegate = self
        sessionsDict[userId] = session
        
        invitationHandler(true, session)
    }
}

extension MultipeerCommunicator: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("\(peerID.displayName) connected")
        case .notConnected:
            print("\(peerID.displayName) not connected")
        case .connecting:
            print("\(peerID.displayName) connecting")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            // Протокол, описанный в задании не позволяет нормально использовать Codable объекты :(
            let message = try JSONDecoder().decode(Message.self, from: data)
            delegate?.didReceiveMessage(text: message.text,
                                        fromUser: User.current.id,
                                        toUser: peerID.displayName)
        } catch {
            print("didReceive data error \(error.localizedDescription)")
        }
    }
}

