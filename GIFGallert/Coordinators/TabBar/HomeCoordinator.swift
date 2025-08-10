//
//  HomeCoordinator.swift
//  GIFGallert
//
//  Created by Hamzeh on 07/08/2025.
//

import UIKit

final class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    var parentCoordinator: (Coordinator)?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        childCoordinators = []
    }
    
    func start() {
        let homeService = HomeService()
        let favoritesService = FavoritesService()
        let viewModel = HomeViewModel(homeService: homeService, favoritesService: favoritesService)
        let homeViewController = HomeViewController(viewModel: viewModel)
        
        viewModel.navigateToDetails = { [weak self] model in
            guard let self else { return }
            pushDetailsViewController(model: model)
        }
        
        navigationController.pushViewController(homeViewController, animated: false)
    }
    
    private func pushDetailsViewController(model: DetailsViewModel) {
        let detailsViewController = DetailsViewController(viewModel: model)
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
