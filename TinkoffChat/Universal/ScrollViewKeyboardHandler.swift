//
//  KeyboardScrollViewProtocol.swift
//  McDonalds-IOS-Swift
//
//  Created by Mihail Babaev on 23.08.17.
//  Copyright © 2017 rubeacon. All rights reserved.
//

import UIKit

protocol ScrollViewKeyboardHandler: class {
    var scrollView: UIScrollView { get }
    var activeField: UITextField? { get set }
}

extension ScrollViewKeyboardHandler where Self: UIViewController {
    func registerForKeyboardNotifications() {
        //Adding notifies on keyboard appearing
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil, queue: nil) { notification in
            self.keyboardWillShow(notification: notification)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide, object: nil, queue: nil) { notification in
            self.keyboardWillHide(notification: notification)
        }
        
        self.scrollView.keyboardDismissMode = .onDrag
    }
    
    func deregisterFromKeyboardNotifications() {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: Notification) {
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        guard let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect = self.navigationController?.view.frame ?? self.view.frame
        aRect.size.height -= keyboardSize.height
        if let activeField = self.activeField {
            self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
        }

    }
    
//    func scrollRectToVisible(view: UIView) {
//        if let view = scrollView.subviews.first {
//            var fieldFrame = view.convert(view.frame, to: scrollView)
//            fieldFrame.origin.y = fieldFrame.origin.y
//            self.scrollView.scrollRectToVisible(fieldFrame, animated: true)
//        }
//    }
    
    func keyboardWillHide(notification: Notification) {
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
}

