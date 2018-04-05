//
//  Conversation.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 05.04.2018.
//  Copyright © 2018 mbabaev. All rights reserved.
//

import Foundation

class Conversation {
    
    
    var messages = [Message]() {
        didSet {
            date = Date()
        }
    }
    
    var user: User
    
    var date: Date = Date()
    var hasUnreadMessages: Bool = false
    
    var isOnline: Bool = true

    
    init(userID: String, userName: String) {
        self.user = User(id: userID, name: userName)
    }
}
