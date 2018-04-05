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
    
    init(text: String) {
        self.text = text
        self.messageId = MCMessage.generateMessageId()
        self.eventType = "TextMessage"
    }
    
    func data() throws -> Data {
        let encoder = JSONEncoder()
        let messageData = try encoder.encode(self)
        return messageData
    }
    
    static func generateMessageId() -> String {
        return "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)".data(using: .utf8)!.base64EncodedString()
    }
    
    static func message(from data: Data) -> MCMessage? {
        return try? JSONDecoder().decode(MCMessage.self, from: data)
    }
}






