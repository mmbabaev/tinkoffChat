//
//  MessageTableViewCell.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 16.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import UIKit

protocol MessageCellConfiguration: class {
    var message: String? { get set }
}

class MessageTableViewCell: UITableViewCell, MessageCellConfiguration {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var message: String? {
        didSet {
            messageLabel.text = message
        }
    }
}
