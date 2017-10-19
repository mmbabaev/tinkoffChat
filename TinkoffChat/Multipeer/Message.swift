//
//  Message.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 18.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import Foundation

struct MCMessage: Encodable, Decodable {
    let eventType: String
    let messageId: String
    let text: String
}




struct Message {
    private(set) var text: String
    let isIncoming: Bool
    
    init(length: Int, isIncoming: Bool) {
        text = ""
        for _ in 0...length {
            text = "\(text)A"
        }
        
        self.isIncoming = isIncoming
    }
    
    static var testMessages = [
        Message(length: 1, isIncoming: true),
        Message(length: 30, isIncoming: true),
        Message(length: 300, isIncoming: true),
        Message(length: 1, isIncoming: false),
        Message(length: 30, isIncoming: false),
        Message(length: 300, isIncoming: false)
    ]
}
