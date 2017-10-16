//
//  UIViewController+Alerts.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 16.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import UIKit

extension UIViewController {
    private func errorAlertController(message: String, repeatedBlock: (() -> Void)?) -> UIAlertController {
        let controller = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        
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
    
    func showErrorAlert(message: String, repeatedBlock: (() -> Void)? = nil) {
        let controller = errorAlertController(message: message, repeatedBlock: repeatedBlock)
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func showAlert(title: String = "", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
