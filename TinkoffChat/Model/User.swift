//
//  User.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 23.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import Foundation
import MultipeerConnectivity


class User {
    let id: String
    let name: String
    
    var messages: [Message]
    
    var lastMessage: Message? {
        return messages.last
    }
    
    var hasUnreadMessages: Bool {
        for message in messages {
            if message.isNew {
                return true
            }
        }
        
        return false
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        messages = []
    }
    
    static let current: User = {
        let id = UIDevice.current.identifierForVendor!.uuidString
        let name = UIDevice.current.name
        return User(id: id, name: name)
    }()
}
