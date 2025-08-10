//
//  HomeViewModel.swift
//  GIFGallert
//
//  Created by Hamzeh on 08/08/2025.
//

import Foundation

final class HomeViewModel {
    var onLoadData: (([ItemTableviewCellVM], [IndexPath]) -> Void)?
    var homeDataError: ((String) -> Void)?
    var homeCellViewModels: [ItemTableviewCellVM] = []
    var navigateToDetails: ((DetailsViewModel) -> Void)?
    
    private var currentPage = 1
    private var offset: Int = 0
    var hasMoreData: Bool = true
    
    var isFirstPage: Bool {
        currentPage == 1
    }
    
    private let homeService: HomeService
    private let favoritesService: FavoritesService
    init(homeService: HomeService, favoritesService: FavoritesService) {
        self.homeService = homeService
        self.favoritesService = favoritesService
    }
    
    var dataIndexPaths: [IndexPath] {
        (offset...homeCellViewModels.count-1)
            .map {IndexPath(row: $0, section: 0) }
    }
    
    func goToDetails(cellVM: ItemTableviewCellVM) {
        let mappedDetailsModel = DetailsViewModel(
            id: cellVM.id,
            title: cellVM.title,
            username: cellVM.username,
            type: cellVM.type,
            slug: cellVM.slug,
            url: cellVM.url,
            imageURL: cellVM.gifURL,
            favoritesService: favoritesService
        )
        navigateToDetails?(mappedDetailsModel)
    }
}
//MARK: - Fetching data
extension HomeViewModel {
    func fetchInitialData() {
        currentPage = 1
        homeCellViewModels.removeAll()
        fetchHomeData()
    }
    
    func loadMoreData() {
        currentPage += 1
        fetchHomeData()
    }
    
    func fetchHomeData() {
        homeService.fetchItems(pageNumber: currentPage) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let paginationResponse):
                let mappedViewModels = paginationResponse.data.map(mapAndBindViewModel)
                homeCellViewModels.append(contentsOf: mappedViewModels)
                offset = paginationResponse.pagination.offset
                hasMoreData = hasMoreDataToLoad(pageResponse: paginationResponse.pagination)
                onLoadData?(mappedViewModels, dataIndexPaths)
                
            case .failure(let error):
                homeDataError?(error.localizedDescription)
            }
        }
    }
    
    private func mapAndBindViewModel(_ model: ItemResponseModel) -> ItemTableviewCellVM {
        let viewModel = ItemTableviewCellVM(
            id: model.id,
            gifURL: model.images.original.url,
            title: model.title,
            username: model.username,
            isFavorite: favoritesService.isFavorite(model.id), type: model.type,
            slug: model.slug,
            url: model.url
        )
        bind(viewModel: viewModel)
        return viewModel
    }
    
    private func bind(viewModel: ItemTableviewCellVM) {
        viewModel.onFavoriteTapped = { [weak self] in
            guard let self else { return }
            let isAddingFavorite = self.isAddingFavorite(id: viewModel.id)
            viewModel.isFavorite = isAddingFavorite
        }
    }
    
    private func hasMoreDataToLoad(pageResponse: PaginationResponseModel) -> Bool {
        return pageResponse.offset + pageResponse.count < pageResponse.total_count
    }
}
//MARK: - Favorites Handling
extension HomeViewModel {
    func isAddingFavorite(id: String) -> Bool {
        if favoritesService.isFavorite(id) {
            favoritesService.remove(id: id)
            return false
        } else {
            findAndAddToFavorites(id: id)
            return true
        }
    }
    
    func findAndAddToFavorites(id: String) {
        guard let cellViewModel = homeCellViewModels.first(where: {$0.id == id}) else { return }
        favoritesService.add(
            FavoriteModel(id: cellViewModel.id,
                          title: cellViewModel.title,
                          username: cellViewModel.username,
                          type: cellViewModel.type,
                          slug: cellViewModel.slug,
                          url: cellViewModel.url,
                          imageURL: cellViewModel.gifURL
                         )
        )
    }
    
    func checkFavorites() {
        homeCellViewModels.forEach { cellViewModel in
            cellViewModel.isFavorite = self.favoritesService.isFavorite(cellViewModel.id)
        }
    }
}
