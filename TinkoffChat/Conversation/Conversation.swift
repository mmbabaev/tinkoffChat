//
//  Conversation.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 16.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import Foundation

struct Conversation {
    let name: String
    let lastMessage: String?
    let date: Date?
    let hasUnreadMessages: Bool
    
    static var testConversations: [Conversation] {
        return [
            Conversation(name: "Один",
                         lastMessage:"тестовое сообщение",
                         date: Date(),
                         hasUnreadMessages: false),
            
            Conversation(name: "2 пользователь",
                         lastMessage:"тестовое сообщение",
                         date: Date(timeIntervalSince1970: 1476568414),
                         hasUnreadMessages: true),
            
            Conversation(name: "3 пользователь",
                         lastMessage:nil,
                         date: Date(),
                         hasUnreadMessages: false),
            
            Conversation(name: "4 пользователь",
                         lastMessage:"тестовое сообщение",
                         date: Date(timeIntervalSince1970: 1476568414),
                         hasUnreadMessages: true),
            
            Conversation(name: "5 пользователь",
                         lastMessage:"тестовое сообщение",
                         date: Date(),
                         hasUnreadMessages: false),
            
            Conversation(name: "6 пользователь",
                         lastMessage:nil,
                         date: Date(timeIntervalSince1970: 1476568414),
                         hasUnreadMessages: true),
            
            Conversation(name: "7 пользователь",
                         lastMessage:"тестовое сообщение",
                         date: Date(timeIntervalSince1970: 1476568414),
                         hasUnreadMessages: false),
            
            Conversation(name: "8 пользователь",
                         lastMessage:"тестовое сообщение",
                         date: Date(),
                         hasUnreadMessages: true),
            
            Conversation(name: "9 пользователь",
                         lastMessage:"тестовое сообщение",
                         date: Date(timeIntervalSince1970: 1476568414),
                         hasUnreadMessages: false),
            
            Conversation(name: "пользователь 10",
                         lastMessage:nil,
                         date: Date(),
                         hasUnreadMessages: false),
        ]
    }
}
