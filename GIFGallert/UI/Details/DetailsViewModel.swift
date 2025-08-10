//
//  DetailsViewModel.swift
//  GIFGallert
//
//  Created by Hamzeh on 10/08/2025.
//

final class DetailsViewModel {
    let id: String
    let title: String
    let username: String
    let type: String
    let slug: String
    let url: String
    let imageURL: String
    
    let isFavorite: Bool
    var updateToFavorite: ((Bool) -> Void)?
    private let favoritesService: FavoritesService
    
    init(id: String, title: String, username: String, type: String, slug: String, url: String, imageURL: String, favoritesService: FavoritesService) {
        self.id = id
        self.title = title
        self.username = username
        self.type = type
        self.slug = slug
        self.url = url
        self.imageURL = imageURL
        self.favoritesService = favoritesService
        self.isFavorite = favoritesService.isFavorite(id)
    }
    
    func handleFavoriteTap() {
        if isFavorite {
            favoritesService.remove(id: id)
            updateToFavorite?(false)
        } else {
            favoritesService.add(FavoriteModel(id: id, title: title, username: username, type: type, slug: slug, url: url, imageURL: imageURL))
            updateToFavorite?(true)

        }
    }
}
