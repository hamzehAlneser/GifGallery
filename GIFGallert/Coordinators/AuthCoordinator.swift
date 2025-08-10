//
//  AuthCoordinator.swift
//  GIFGallert
//
//  Created by Hamzeh on 07/08/2025.
//

import UIKit

final class AuthCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    var parentCoordinator: (Coordinator)?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        childCoordinators = []
    }
    
    func start() {
        let authService = AuthService()
        let viewModel = LoginViewModel(authService: authService)
        
        viewModel.navigateToHome = { [weak self] in
            guard let self else { return }
            self.startTabBarCoordinator() 
        }
        
        let loginViewController = LoginViewController(viewModel: viewModel)
        navigationController.pushViewController(loginViewController, animated: false)
    }
    
    private func startTabBarCoordinator() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator.parentCoordinator = self
        tabBarCoordinator.onLogout = { [weak self] in
            self?.handleLogout()
        }
        childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start()
    }
    
    private func handleLogout() {
        childCoordinators.removeAll()
        navigationController.setViewControllers([], animated: false)
        start()
    }
}
