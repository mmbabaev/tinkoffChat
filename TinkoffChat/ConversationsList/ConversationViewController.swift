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
    
    @IBOutlet weak var messageTextField: UITextField!
    var conversation: Conversation!
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.keyboardDismissMode = .onDrag
        
        self.title = conversation.user.name
        
        tableView.reloadData()
        
        NotificationCenter.default.addObserver(forName: Notification.Name.conversationWasUpdated, object: self, queue: nil) { (notification) in
            self.handle(notification: notification)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ConversationViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ConversationViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        
        self.endLoading()
    }
    
    func reload() {
        self.tableView?.reloadData()
    }
    
    func handle(notification: Notification) {
        if let notificationConversation = notification.object as? Conversation,
            notificationConversation.user.id == self.conversation.user.id {
            
            self.conversation = notificationConversation
            self.reload()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func sendButtonClicked(_ sender: UIButton) {
        guard let text = messageTextField.text else { return }
        
        startLoading()
        MultipeerCommunicator.shared.sendMessage(string: text, to: conversation.user.id) { (success, error) in
            
            self.endLoading()
            
            if success {
                self.conversation.messages.append(Message(text: text, isIncoming: false))
                self.reload()
                self.messageTextField.text = ""
                self.view.endEditing(true)
            } else {
                self.showErrorAlert(message: "Не удалось отправить сообщение")
            }
        }
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    private func endLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = conversation.messages[indexPath.row]
        
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
