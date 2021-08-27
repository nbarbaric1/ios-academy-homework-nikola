//
//  KeyboardHandlingExtension.swift
//  ScrollView
//
//  Created by Infinum on 30.07.2021..
//

import UIKit

extension UIScrollView {
    func handleKeyboard() -> [NSObjectProtocol] {
        
        var notificationTokens: [NSObjectProtocol] = []
        
        let keyboardShowNotification =
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            guard let self = self,
                  let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as?
                    NSValue
            else { return }
            
            let height = value.cgRectValue.size.height / 3
            self.contentSize = CGSize(width: self.frame.width, height: self.frame.height + height)
            let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
            self.setContentOffset(bottomOffset, animated: true)
        }
        
        let keyboardHideNotification =
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                                   object: nil,
                                                   queue:.main) { [weak self] notification in
            guard let self = self,
                  let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else { return }
            
            let height = value.cgRectValue.size.height / 3
            self.contentSize = CGSize(width: self.frame.width, height: self.frame.height - height)
        }
        notificationTokens.append(keyboardShowNotification)
        notificationTokens.append(keyboardHideNotification)
        return notificationTokens
    }
    
    func deleteObservers(for notificationToken: NSObjectProtocol) {
        NotificationCenter.default.removeObserver(notificationToken)
    }
}




