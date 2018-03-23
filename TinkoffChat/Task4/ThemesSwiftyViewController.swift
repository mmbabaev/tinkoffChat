//
//  ThemesSwiftyViewController.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 23.03.2018.
//  Copyright © 2018 mbabaev. All rights reserved.
//

import UIKit

class ThemesSwiftyViewController: UIViewController {
    
    var colorChangeBlock: ((UIColor) -> Void)?
    
    private(set) var model = Themes()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    private func selectTheme(sender: UIButton) {
        let title = sender.titleLabel?.text
        let color: UIColor
        if title == "Тема 1" {
            color = model.theme1
        } else if title == "Тема 2" {
            color = model.theme2
        } else {
            color = model.theme3
        }
        
        changeTheme(selectedTheme: color)
    }
    
    private func changeTheme(selectedTheme: UIColor) {
        self.view.backgroundColor = selectedTheme;
        colorChangeBlock?(selectedTheme)
    }
    
}
