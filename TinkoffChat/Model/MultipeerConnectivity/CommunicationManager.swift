//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 23.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import Foundation

protocol CommunicationDelegate {
    func didUsersUpdate()
}

class CommunicationManager: CommunicatorDelegate {
    
    var onlineUsers: [User] = []
    var usersDict: [String : User] = [:]
    
    var delegate: CommunicationDelegate
    
    var communicator: Communicator = MultipeerCommunicator()
    
    init(delegate: CommunicationDelegate) {
        self.delegate = delegate
        
        communicator.delegate = self
    }
    
    func didFoundUser(userID: String, userName: String) {
        let user = User(id: userID, name: userName)
        onlineUsers.append(user)
        usersDict[userID] = user
        
        delegate.didUsersUpdate()
    }
    
    func didLostUser(userID: String) {
        onlineUsers = onlineUsers.filter({ $0.id != userID })
        usersDict.removeValue(forKey: userID)
        
        delegate.didUsersUpdate()
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    
    func failedToStartAdvertising(error: Error) {
        
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        
    }
    
    
}
