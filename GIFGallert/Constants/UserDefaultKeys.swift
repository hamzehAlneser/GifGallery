//
//  UserDefaultKeys.swift
//  GIFGallert
//
//  Created by Hamzeh on 07/08/2025.
//

enum UserDefaultsKeys {
    case isLoggedIn, favorites
}

extension UserDefaultsKeys {
    var stringValue: String {
        switch self {
        case .isLoggedIn:
            return "isLoggedIn"
        case .favorites:
            return "favorites"
        }
    }
}
