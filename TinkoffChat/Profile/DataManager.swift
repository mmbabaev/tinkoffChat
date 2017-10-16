//
//  DataManager.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 16.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import Foundation

protocol DataManager {
    func save(data: Data, to file: String, callback: @escaping (Bool) -> Void)
    func read(from file: String, callback: @escaping (Data?) -> Void)
}

