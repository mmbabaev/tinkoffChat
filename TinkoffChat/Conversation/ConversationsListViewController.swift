//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 16.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConversationsListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private let onlineSection = 0
    private let cellId = "ConversationCellIdentifier"
    
    private let sections = ["Online", "History"]
    private let onlineConversations = Conversation.testConversations
    private let historyConversations = Conversation.testConversations
    
    
    @IBAction func multipeer(_ sender: Any) {
        let manager = MCManager.shared
        
        manager.browser.startBrowsingForPeers()
        
        let vc = MCBrowserViewController(browser: manager.browser, session: manager.session)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Tinkoff Chat"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow,
            let vc = segue.destination as? ConversationViewController,
            segue.identifier == "showConversation" {
            
            let row = selectedIndexPath.row
            let conversation: Conversation
            if selectedIndexPath.section == onlineSection {
                conversation = onlineConversations[row]
            } else {
                conversation = historyConversations[row]
            }
            
            vc.conversation = conversation
            
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
        
        
    }
}

extension ConversationsListViewController: UITableViewDelegate {
    
}

extension ConversationsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == onlineSection {
            return onlineConversations.count
        }
        
        return historyConversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conversation: Conversation
        let online: Bool
        
        if indexPath.section == onlineSection {
            conversation = onlineConversations[indexPath.row]
            online = true
        } else {
            conversation = historyConversations[indexPath.row]
            online = false
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let cellConfiguration = cell as? ConversationCellConfiguration {
            cellConfiguration.name = conversation.name
            cellConfiguration.message = conversation.lastMessage
            cellConfiguration.hasUnreadMessage = conversation.hasUnreadMessages
            cellConfiguration.date = conversation.date
            cellConfiguration.online = online
        }
        
        return cell
    }
    
    
}

