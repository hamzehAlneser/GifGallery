//
//  MainCoordinator.swift
//  GIFGallert
//
//  Created by Hamzeh on 07/08/2025.
//
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    var parentCoordinator: (Coordinator)?
    
    var navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        childCoordinators = []
    }
    
    func start() {
        if isLoggedIn() {
            startTabBarCoordinator()
        } else {
            startAuthCoordinator()
        }
    }
}

// MARK: - Flow Check
extension MainCoordinator {
    private func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLoggedIn.stringValue)
    }
    
    private func startAuthCoordinator() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)
        childCoordinators.append(authCoordinator)
        authCoordinator.parentCoordinator = self
        authCoordinator.start()
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
