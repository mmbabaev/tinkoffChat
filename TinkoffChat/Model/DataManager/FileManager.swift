//
//  FileManager.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 16.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import Foundation

extension FileManager {
    var documentDirectory: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func save(data: Data, to file: String) -> Bool {
        if let oldData = read(from: file),
            oldData == data {
            // Don't save data if we have equals one
            return true
        }
        
        if let dir = documentDirectory {
            let fileURL = dir.appendingPathComponent(file)
            
            do {
                try data.write(to: fileURL)
                return true
            }
            catch {
                return false
            }
        } else {
            return false
        }
    }
    
    func read(from file: String) -> Data? {
        guard let dir = documentDirectory else {
            return nil
        }
        
        let fileURL = dir.appendingPathComponent(file)
        do {
            let data = try Data(contentsOf: fileURL)
            return data
        }
        catch {
            return nil
        }
    }
}
