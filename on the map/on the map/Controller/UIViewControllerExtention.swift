//
//  UIViewControllerExtention.swift
//  on the map
//
//  Created by Abdulla Hasanov on 11/25/19.
//  Copyright © 2019 Abdulla Hasanov. All rights reserved.
//

import UIKit

extension UIViewController: UITextFieldDelegate {
    
    // stub to override
    @objc func getActiveField() -> UITextField? {
        return nil
    }
    
    // stub to override
    @objc func setActiveField(_ activeField: UITextField?) { }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        setActiveField(textField)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        setActiveField(nil)
        return true
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        var aRect: CGRect = self.view.frame
        aRect.size.height -= getKeyboardHeight(notification)
        if let activeField = getActiveField() {
            if(!aRect.contains((activeField.superview?.convert(activeField.frame.origin, to: nil))!)) {
                view.frame.origin.y = -getKeyboardHeight(notification)
            } else {
                debugPrint("not contains")
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
