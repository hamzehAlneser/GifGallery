//
//  SearchCoordinator.swift
//  GIFGallert
//
//  Created by Hamzeh on 10/08/2025.
//

import UIKit

final class SearchCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    var parentCoordinator: (Coordinator)?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        childCoordinators = []
    }
    
    func start() {
        let favoritesService = FavoritesService()
        let searchService = SearchService()
        let homeService = HomeService()
        let viewModel = SearchViewModel(
            homeService: homeService,
            favoritesService: favoritesService,
            searchService: searchService
        )
        
        let searchViewController = SearchViewController(viewModel: viewModel)
        
        viewModel.navigateToDetails = { [weak self] model in
            guard let self else { return }
            pushDetailsViewController(model: model)
        }
        
        navigationController.pushViewController(searchViewController, animated: false)
    }
    
    private func pushDetailsViewController(model: DetailsViewModel) {
        let detailsViewController = DetailsViewController(viewModel: model)
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}

