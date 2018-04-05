//
//  ChatManager.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 05.04.2018.
//  Copyright © 2018 mbabaev. All rights reserved.
//

import Foundation

protocol CommunicationManagerDelegate: class {
    func communicationManagerDidUpdateConversations(_ communicationManager: CommunicationManager)
    
    func communicationmanager(_ communicationManager: CommunicationManager,
                              didUpdateConversation conversation: Conversation,
                              at row: Int)
}

class CommunicationManager: CommunicatorDelegate {
    
    static let shared = CommunicationManager()
    
    weak var delegate: CommunicationManagerDelegate?
    
    var conversations: [Conversation] {
        //todo sort
        return Array(self.userConvertationDict.values)
    }
    
    var userConvertationDict = [String : Conversation]() {
        didSet {
            self.updateAllConversations()
        }
    }
    
    var onlineConversations = [Conversation]()
    var historyConversations = [Conversation]()
    
    func updateAllConversations() {
        let conversations = self.conversations.sorted { (conversation1, conversation2) -> Bool in
            return conversation1.date < conversation2.date
        }
        
        self.onlineConversations = []
        self.historyConversations = []
        
        for conversation in conversations {
            if conversation.isOnline {
                onlineConversations.append(conversation)
            } else {
                historyConversations.append(conversation)
            }
        }
    }

    
    func update(conversation: Conversation) {
        if let index = index(for: conversation.user.id) {
            delegate?.communicationmanager(self, didUpdateConversation: conversation, at: index)
        }
        
        delegate?.communicationManagerDidUpdateConversations(self)
    }
    
    func index(for userID: String) -> Int? {
        for (index, conversation) in conversations.enumerated() {
            if conversation.user.id == userID {
                return index
            }
        }
        return nil
    }
    
    func didFoundUser(userID: String, userName: String?) {
        if let conversation = userConvertationDict[userID] {
            conversation.isOnline = true
            self.update(conversation: conversation)
            return
        }
        
        let conversation = Conversation(userID: userID, userName: userName ?? "ANONYMOUS")
        userConvertationDict[userID] = conversation
        delegate?.communicationManagerDidUpdateConversations(self)
    }
    
    func didLostUser(userID: String) {
        if let conversation = userConvertationDict[userID] {
            conversation.isOnline = false
            update(conversation: conversation)
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print("error")
    }
    
    func failedToStartAdvertising(error: Error) {
        print("error")
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        if let conversation = userConvertationDict[fromUser] {
            let message = Message(text: text)
            conversation.messages.append(message)
            update(conversation: conversation)
        }
    }
    
    func send(text: String, to conversation: Conversation) {
        self.send(text: text, to: conversation.user.id)
    }
    
    func send(text: String, to userID: String) {
        MultipeerCommunicator.shared.sendMessage(string: text, to: userID) { success, error in
            if success {
                self.message(with: text, wasSuccessfullySendTo: userID)
            } else {
                print(error?.localizedDescription ?? "UNKNOWN SEND ERROR")
            }
        }
    }
    
    func message(with text: String, wasSuccessfullySendTo userID: String) {
        guard let conversation = self.userConvertationDict[userID] else {
            return
        }
        
        let message = Message(text: text, isIncoming: false)
        conversation.messages.append(message)
        self.update(conversation: conversation)
    }
}
