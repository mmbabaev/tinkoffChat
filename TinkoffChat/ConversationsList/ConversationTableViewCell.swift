//
//  ConversationTableViewCell.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 16.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import UIKit

protocol ConversationCellConfiguration: class {
    var name: String? { get set }
    var message: String? { get set }
    var date: Date? { get set }
    var online: Bool { get set }
    var hasUnreadMessage: Bool { get set }
}

class ConversationTableViewCell: UITableViewCell, ConversationCellConfiguration {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var message: String? {
        didSet {
            messageLabel.text = message ?? "No messages yet"
        }
    }
    
    var date: Date? {
        didSet {
            if let date = self.date {
                dateLabel.text = string(for: date)
            } else {
                dateLabel.text = ""
            }
        }
    }
    
    var online: Bool = false {
        didSet {
            if online {
                self.backgroundColor = .tinkoffYellow
            } else {
                self.backgroundColor = .white
            }
        }
    }
    
    var hasUnreadMessage: Bool = false {
        didSet {
            let size = CGFloat(17)
            
            if hasUnreadMessage {
                messageLabel.font = UIFont.boldSystemFont(ofSize: size)
            } else {
                messageLabel.font = UIFont.systemFont(ofSize: size)
            }
        }
    }
    

    private func string(for date: Date) -> String {
        let formatter: DateFormatter
        
        if Calendar.current.isDateInToday(date) {
            formatter = DateFormatter.timeFormatter
        } else {
            formatter = DateFormatter.dayFormatter
        }
        
        return formatter.string(from: date)
    }
}
