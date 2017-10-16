//
//  RoundButton.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 02.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import Foundation
import UIKit

class RoundButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        self.layer.cornerRadius = Constants.buttonCornerRadius
        self.layer.borderColor = self.currentTitleColor.cgColor
        self.layer.borderWidth = Constants.buttonBorderWidth
    }
}
