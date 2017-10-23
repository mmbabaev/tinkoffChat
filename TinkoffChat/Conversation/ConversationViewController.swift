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
    
    var user: User!
    var manager: CommunicationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.title = user.name
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil, queue: nil) { notification in
            self.keyboardWillShow(notification: notification)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide, object: nil, queue: nil) { notification in
            self.keyboardWillHide(notification: notification)
        }
        
        manager.communicator.invite(userID: user.id)
    }
    
    @IBAction func sendClicked(_ sender: UIButton) {
        let messageText = messageTextField.text ?? ""
        
        manager.communicator.sendMessage(string: messageText, to: user.id) {
            success, error in
            
            if success {
                self.messageTextField.text = ""
                
                let message = Message(text: messageText)
                self.user.messages.append(message)
            } else {
                print(error?.localizedDescription ?? "")
                self.showErrorAlert(message: "Не удалось отправить сообщение")
            }
        }
    }
    
    // Keyboard handlers:
    func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        self.view.frame.origin.y = -keyboardSize.height
    }
    
    func keyboardWillHide(notification: Notification) {
        self.view.frame.origin.y = 0
    }
}


extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = user.messages[indexPath.row]
        
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
