//
//  DateFormatter.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 16.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let timeFormatter: DateFormatter = {
        return formater(format: "HH:mm")
    }()
    
    static let dayFormatter: DateFormatter = {
        return formater(format: "dd MMM")
    }()
    
    private static func formater(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter
    }
}
