//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 16.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private let onlineSection = 0
    private let cellId = "ConversationCellIdentifier"
    
    private let sections = ["Online", "History"]
    private var onlineUsers: [User] = []
    private let historyConversations = [User]()
    
    private var manager: CommunicationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CommunicationManager(delegate: self)

        self.title = "Tinkoff Chat"
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow,
            let vc = segue.destination as? ConversationViewController,
            segue.identifier == "showConversation" {
            
            let row = selectedIndexPath.row
            
            if selectedIndexPath.section == onlineSection {
                vc.user = onlineUsers[row]
            } else {
                vc.user = historyConversations[row]
            }
            
            vc.manager = manager
            
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
            return onlineUsers.count
        }
        
        return historyConversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user: User
        let online: Bool
        
        if indexPath.section == onlineSection {
            user = onlineUsers[indexPath.row]
            online = true
        } else {
            user = historyConversations[indexPath.row]
            online = false
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let cellConfiguration = cell as? ConversationCellConfiguration {
            cellConfiguration.name = user.name
            
            cellConfiguration.message = user.lastMessage?.text
            cellConfiguration.hasUnreadMessage = user.hasUnreadMessages
            cellConfiguration.date = user.lastMessage?.date
            cellConfiguration.online = online
        }
        
        return cell
    }
    
    func reload() {
        onlineUsers = manager.onlineUsers
        
        tableView.reloadData()
    }
}

extension ConversationsListViewController: CommunicationDelegate {
    func didUsersUpdate() {
        self.reload()
    }
    
    
}



