//
//  Message.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 16.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import Foundation

enum MCError: Error {
    case wrongType
}

protocol Event {
    var type: String { get }
}

struct Message: Event {
    
    var type: String {
        return "TextMessage"
    }

    let id: String
    let text: String
    let date: Date
    
    var user: User?
    
    let isIncoming: Bool
    var isNew: Bool = true
    
    init(text: String, isIncoming: Bool = false) {
        self.text = text
        
        self.isIncoming = isIncoming
        self.date = Date()
        self.id = Message.generateMessageId()
    }
    
    private static func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
}

extension Message: Codable {
    enum CodingKeys: String, CodingKey {
        case text
        case id = "messageId"
        case eventType
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        text = try values.decode(String.self, forKey: .text)
        date = Date()
        
        isIncoming = true
        
        let eventType = try values.decode(String.self, forKey: .eventType)
        if eventType != self.type {
            throw MCError.wrongType
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)
        try container.encode(type, forKey: .eventType)
    }
}
