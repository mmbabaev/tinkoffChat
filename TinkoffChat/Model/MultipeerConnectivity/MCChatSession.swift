//
//  MCChatSession.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 23.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import MultipeerConnectivity
import Foundation

class MCChatSession: MCSession {
    let targetPeer: MCPeerID
    
    init(peer: MCPeerID, targetPeer: MCPeerID) {
        self.targetPeer = targetPeer
        
        super.init(peer: peer, securityIdentity: nil, encryptionPreference: .none)
    }
}
