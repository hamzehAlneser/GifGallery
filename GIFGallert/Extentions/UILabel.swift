//
//  UILabel.swift
//  GIFGallert
//
//  Created by Hamzeh on 07/08/2025.
//

import UIKit

extension UILabel {
    convenience init(
        style: LabelStyle
    ) {
        self.init()
        switch style {
            case .body:
            font = UIFont.systemFont(ofSize: 16)
        case .title:
            font = UIFont.systemFont(ofSize: 24, weight: .bold)
        }
    }
}

enum LabelStyle {
    case title
    case body
}
