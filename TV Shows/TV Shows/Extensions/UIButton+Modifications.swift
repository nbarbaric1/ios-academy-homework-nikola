//
//  UIButton+Modifications.swift
//  TV Shows
//
//  Created by Infinum on 29.07.2021..
//
import UIKit

extension UIButton {
    func enableButton() {
        self.isEnabled = true
        self.alpha = 1
    }
    
    func disableButton() {
        self.isEnabled = false
        self.alpha = 0.5
    }
}
