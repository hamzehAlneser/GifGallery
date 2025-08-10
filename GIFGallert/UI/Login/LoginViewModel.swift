//
//  LoginViewModel.swift
//  GIFGallert
//
//  Created by Hamzeh on 08/08/2025.
//

import Foundation

final class LoginViewModel {
    private let authService: AuthService
    init(authService: AuthService) {
        self.authService = authService
    }

    var navigateToHome: (() -> Void)?
    var onLoginFailure: ((String) -> Void)?

    func login(email: String, password: String)  {
        guard !email.isEmpty, !password.isEmpty else {
            onLoginFailure?("Email or password can't be empty.")
            return
        }
        
        authService.login(email: email, password: password) { result in
            switch result {
            case .success:
                UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isLoggedIn.stringValue)
                self.navigateToHome?()
            case .failure(let error):
                self.onLoginFailure?(error.localizedDescription)
            }
        }
    }
}
