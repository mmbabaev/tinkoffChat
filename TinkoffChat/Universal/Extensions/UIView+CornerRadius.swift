//
//  UIView+CornerRadius.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 02.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func roundCorners() {
        let width = self.frame.width
        let height = self.frame.height
        let radius = width > height ? width : height
        self.layer.cornerRadius = radius / 2
    }
}
