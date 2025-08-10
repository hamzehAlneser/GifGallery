//
//  FavoritesViewModel.swift
//  GIFGallert
//
//  Created by Hamzeh on 09/08/2025.
//

import Foundation

final class FavoritesViewModel {
    var onLoadData: (() -> Void)?
    var favoriteseDataError: ((String) -> Void)?
    var favoritesCellViewModels: [FavoritesCollectionViewCellVM] = []
    var navigateToDetails: ((DetailsViewModel) -> Void)?

    private let favoritesService: FavoritesService
    init(favoritesService: FavoritesService) {
        self.favoritesService = favoritesService
    }
    
    func goToDetails(cellVM: FavoritesCollectionViewCellVM) {
        let mappedDetailsModel = DetailsViewModel(
            id: cellVM.id,
            title: cellVM.title,
            username: cellVM.title,
            type: cellVM.type,
            slug: cellVM.slug,
            url: cellVM.url,
            imageURL: cellVM.imageURL,
            favoritesService: favoritesService
        )
        navigateToDetails?(mappedDetailsModel)
    }
}
//MARK: - Fetching data
extension FavoritesViewModel {
    func fetchFavorites() {
        let favoritesList = favoritesService.fetch()
        let mappedList = favoritesList.map(mapAndBindViewModel)

        favoritesCellViewModels = mappedList
        onLoadData?()
    }
    
    private func mapAndBindViewModel(_ model: FavoriteModel) -> FavoritesCollectionViewCellVM {

        let viewModel = FavoritesCollectionViewCellVM(
            id: model.id,
            title: model.title,
            username: model.username,
            type: model.type,
            slug: model.slug,
            url: model.url,
            imageURL: model.imageURL
        )
        bind(viewModel: viewModel)
        return viewModel
    }
    
    private func bind(viewModel: FavoritesCollectionViewCellVM) {
        viewModel.onRemoveTapped = { [weak self] in
            guard let self else { return }
            self.favoritesService.remove(id: viewModel.id)
            self.favoritesCellViewModels.removeAll { $0.id == viewModel.id }
            self.onLoadData?()
        }
    }
}
