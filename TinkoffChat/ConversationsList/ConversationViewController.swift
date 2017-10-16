//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 16.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import Foundation
import UIKit

private let outcomingCellId = "OutcomingMessageCellId"
private let incomingCellId = "IncomingMessageCellId"

class ConversationViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    var conversation: Conversation!
    
    let messages = Message.testMessages
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.title = conversation.name
    }
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cellId: String
        if message.isIncoming {
            cellId = "IncomingMessageCellId"
        } else {
            cellId = "OutcomingMessageCellId"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let cell = cell as? MessageCellConfiguration {
            cell.message = message.text
        }
        
        return cell
    }
}

extension ConversationViewController: UITableViewDelegate {
    
}
