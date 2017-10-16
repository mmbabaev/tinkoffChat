//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 16.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import Foundation

class DataReadOperation: Operation {
    var data: Data?
    let file: String
    
    init(sourceFile: String) {
        self.file = sourceFile
        
        super.init()
        
        self.qualityOfService = .background
        self.queuePriority = .veryHigh
    }
    
    override func main() {
        if isCancelled { return }
        let data = FileManager.default.read(from: file)
        if isCancelled { return }
        self.data = data
    }
}

class DataWriteOperation: Operation {
    var result = false
    let file: String
    let data: Data
    
    init(data: Data, file: String) {
        self.file = file
        self.data = data
        
        super.init()
        
        self.qualityOfService = .background
        self.queuePriority = .veryHigh
    }
    
    override func main() {
        if isCancelled { return }
        let result = FileManager.default.save(data: data, to: file)
        if isCancelled { return }
        self.result = result
    }
}

class OperationManager: DataManager {
    let queue = OperationQueue()
    
    func save(data: Data, to file: String, callback: @escaping (Bool) -> Void) {
        let operation = DataWriteOperation(data: data, file: file)
        operation.completionBlock = {
            OperationQueue.main.addOperation {
                callback(operation.result)
            }
        }
        
        queue.addOperation(operation)
    }
    
    func read(from file: String, callback: @escaping (Data?) -> Void) {
        let operation = DataReadOperation(sourceFile: file)
        operation.completionBlock = {
            OperationQueue.main.addOperation {
                callback(operation.data)
            }
        }
        
        queue.addOperation(operation)
    }
}
