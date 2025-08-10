//
//  UITextField.swift
//  GIFGallert
//
//  Created by Hamzeh on 07/08/2025.
//

import UIKit

extension UITextField {
    convenience init(
        roundedCorners: CGFloat,
    ) {
        self.init()
        layer.cornerRadius = roundedCorners
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1).cgColor

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 2
        layer.masksToBounds = false
        
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        leftViewMode = .always
    }
}
