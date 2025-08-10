//
//  AuthService.swift
//  GIFGallert
//
//  Created by Hamzeh on 08/08/2025.
//

struct AuthService {
    func login(email: String, password: String, completion: @escaping (Result<Void, CustomErrors>) -> Void) {
        if email.lowercased() == LoginInfo.username.lowercased() && password == LoginInfo.password {
            completion(.success(()))
        } else {
            completion(.failure(.invalidCredentials))
        }
    }
}
