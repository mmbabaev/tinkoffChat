//
//  Message.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 05.04.2018.
//  Copyright © 2018 mbabaev. All rights reserved.
//

import Foundation

struct Message {
    private(set) var text: String
    let isIncoming: Bool
    
    init(mcMessage: MCMessage, isIncoming: Bool = true) {
        self.isIncoming = isIncoming
        self.text = mcMessage.text
    }
    
    init(text: String, isIncoming: Bool = true) {
        self.isIncoming = isIncoming
        self.text = text
    }
}
