//
//  TabBarCoordinator.swift
//  GIFGallert
//
//  Created by Hamzeh on 09/08/2025.
//

import UIKit

class TabBarCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    var parentCoordinator: (Coordinator)?
    var navigationController: UINavigationController
    private var tabBarController: UITabBarController
    var onLogout: (() -> Void)?
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        self.childCoordinators = []
    }

    func start() {
        let homeNavController = UINavigationController()
        let homeCoordinator = startAndGetHomeCoordinator(navigationController: homeNavController)
        
        let favoritesNavController = UINavigationController()
        let favoritesCoordinator = startAndGetFavoritesCoordinator(navigationController: favoritesNavController)
        
        let searchNavController = UINavigationController()
        let searchCoordinator = startAndGetSearchCoordinator(navigationController: searchNavController)

        childCoordinators = [homeCoordinator, favoritesCoordinator, searchCoordinator]
        tabBarController.viewControllers = [homeNavController, favoritesNavController, searchNavController]
        
        homeNavController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        favoritesNavController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), tag: 1)
        searchNavController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)

        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    private func startAndGetHomeCoordinator(navigationController: UINavigationController) -> HomeCoordinator {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.parentCoordinator = self
        homeCoordinator.onLogout = { [weak self] in
            self?.onLogout?()
        }
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
        return homeCoordinator
    }
    
    private func startAndGetFavoritesCoordinator(navigationController: UINavigationController) -> FavoritesCoordinator {
        let favoritesCoordinator = FavoritesCoordinator(navigationController: navigationController)
        childCoordinators.append(favoritesCoordinator)
        favoritesCoordinator.parentCoordinator = self
        favoritesCoordinator.start()
        return favoritesCoordinator
    }
    
    private func startAndGetSearchCoordinator(navigationController: UINavigationController) -> SearchCoordinator {
        let searchCoordinater = SearchCoordinator(navigationController: navigationController)
        childCoordinators.append(searchCoordinater)
        searchCoordinater.parentCoordinator = self
        searchCoordinater.start()
        return searchCoordinater
    }
}
