//
//  UIColor+AppColors.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 29.09.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let tinkoffYellow: UIColor = {
        return UIColor(hex: "#FEDB43")
    }()
    
    static let iconBackground: UIColor = {
        return UIColor(hex: "#3F78F0")
    }()
    
    static let iconBackgroundHighlighted: UIColor = {
        return UIColor(hex: "#000080")
    }()
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        
        if hex.contains("#") {
            scanner.scanLocation = 1
        } else {
            scanner.scanLocation = 0
        }
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
