//
//  UITextField+Value.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 16.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import UIKit

extension UITextField {
    var textValue: String {
        return self.text ?? ""
    }
}
