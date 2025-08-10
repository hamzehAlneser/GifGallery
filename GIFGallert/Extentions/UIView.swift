//
//  UIView.swift
//  GIFGallert
//
//  Created by Hamzeh on 07/08/2025.
//

import UIKit

extension UIView {
    func useCodeLayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
