//
//  UIViewController+Alerts.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 16.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import UIKit

extension UIViewController {
    private func errorAlertController(title: String? = nil, message: String, repeatedBlock: (() -> Void)?) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        controller.addAction(okAction)
        
        if let repeatedBlock = repeatedBlock {
            let repeateAction = UIAlertAction(title: "Повторить", style: .default) { action in
                repeatedBlock()
            }
            
            controller.addAction(repeateAction)
        }
        
        return controller
    }
    
    func showAlert(title: String? = nil, message: String) {
        let controller = errorAlertController(title: title, message: message, repeatedBlock: nil)
        
        self.present(controller, animated: true, completion: nil)
    }
}
