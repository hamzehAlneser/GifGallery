//
//  APIError.swift
//  GIFGallert
//
//  Created by Hamzeh on 09/08/2025.
//

enum CustomErrors: Error {
    case invalidCredentials
    case genralError
    var localizedDescription: String {
        switch self {
        case .invalidCredentials:
            return "Invalid username or password"
        case .genralError:
            return "Something went wrong"
        }
    }
}
