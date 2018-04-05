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
    private var onlineConversations: [Conversation] {
        return CommunicationManager.shared.onlineConversations
    }
    private var historyConversations: [Conversation] {
        return CommunicationManager.shared.historyConversations
    }
    
    @IBAction func multipeer(_ sender: Any) {
        //manager.send(colorName: "Blablaba")
        //let manager = ColorServiceManager()
        
        //manager.stop()
        
        //manager.browser.startBrowsingForPeers()
        
//        let vc = MCBrowserViewController(browser: <#T##MCNearbyServiceBrowser#>, session: <#T##MCSession#>)
//        let vc = MCBrowserViewController(serviceType: "tinkoff-chat", session: manager.session)
        
        //self.navigationController?.pushViewController(vc, animated: true)
        
        //manager.start()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Tinkoff Chat"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        CommunicationManager.shared.delegate = self
    }
    
    var currentConversationVC: ConversationViewController?
    
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
            
            currentConversationVC = vc
            
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
            cellConfiguration.name = conversation.user.name
            cellConfiguration.message = conversation.messages.last?.text
            cellConfiguration.hasUnreadMessage = conversation.hasUnreadMessages
            cellConfiguration.date = conversation.date
            cellConfiguration.online = online
        }
        
        return cell
    }
    
    
}

extension ConversationsListViewController: CommunicationManagerDelegate {
    func communicationManagerDidUpdateConversations(_ communicationManager: CommunicationManager) {
        DispatchQueue.main.async {
            self.currentConversationVC?.reload()
            self.tableView.reloadData()
        }
    }
    
    func communicationmanager(_ communicationManager: CommunicationManager, didUpdateConversation conversation: Conversation, at row: Int) {
        let indexPath = IndexPath(item: row, section: 0)
        
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    
}

