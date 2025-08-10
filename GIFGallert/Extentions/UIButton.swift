//
//  UIButton.swift
//  GIFGallert
//
//  Created by Hamzeh on 07/08/2025.
//

import UIKit

extension UIButton {
    convenience init(
        style: ButtonStyle
    ) {
        self.init()
        switch style {
            case .common:
            backgroundColor = .accent
            titleLabel?.font = .systemFont(ofSize: 16)
            setTitleColor(.white, for: .normal)
            layer.cornerRadius = 20
        }
    }
}

enum ButtonStyle {
    case common
}
