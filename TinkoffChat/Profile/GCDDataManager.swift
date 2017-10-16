//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 16.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import Foundation

class GCDDataManager: DataManager {
    let queue = DispatchQueue.global(qos: .utility)
    
    func save(data: Data, to file: String, callback: @escaping (Bool) -> Void) {
        queue.async {
            let result = FileManager.default.save(data: data, to: file)
            
            DispatchQueue.main.async {
                callback(result)
            }
        }
    }
    
    func read(from file: String, callback: @escaping (Data?) -> Void) {
        queue.async {
            let data = FileManager.default.read(from: file)
            
            DispatchQueue.main.async {
                callback(data)
            }
        }
    }
}
