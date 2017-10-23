//
//  Communicator.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 23.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import Foundation

protocol Communicator {
    func invite(userID: String)
    func sendMessage(string: String,
                     to userID: String,
                     completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
    weak var delegate: CommunicatorDelegate? { get set }
    var online: Bool { get set }
}

protocol CommunicatorDelegate: class {
    //discovering
    func didFoundUser(userID: String, userName: String)
    func didLostUser(userID: String)
    
    //errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    //messages
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}
