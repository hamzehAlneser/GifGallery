//
//  FavoritesCoordinator.swift
//  GIFGallert
//
//  Created by Hamzeh on 09/08/2025.
//

import UIKit

final class FavoritesCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    var parentCoordinator: (Coordinator)?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        childCoordinators = []
    }
    
    func start() {
        let favoritesService = FavoritesService()
        let viewModel = FavoritesViewModel(favoritesService: favoritesService)
        let favoritesViewController = FavoritesViewController(viewModel: viewModel)
        
        viewModel.navigateToDetails = { [weak self] model in
            guard let self else { return }
            pushDetailsViewController(model: model)
        }
        
        navigationController.pushViewController(favoritesViewController, animated: false)
    }
    
    private func pushDetailsViewController(model: DetailsViewModel) {
        let detailsViewController = DetailsViewController(viewModel: model)
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
