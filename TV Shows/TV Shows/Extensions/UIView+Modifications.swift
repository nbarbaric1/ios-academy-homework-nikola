//
//  UIButton+Modifications.swift
//  TV Shows
//
//  Created by Infinum on 29.07.2021..
//

import UIKit

extension UIView {
    func makeRounded(withCornerRadius radius: Double) {
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
    }
}
