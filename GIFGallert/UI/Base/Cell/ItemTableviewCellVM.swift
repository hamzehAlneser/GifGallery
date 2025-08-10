//
//  ItemTableviewCellVM.swift
//  GIFGallert
//
//  Created by Hamzeh on 09/08/2025.
//

import UIKit

final class ItemTableviewCellVM {
    let id: String
    let gifURL: String
    let title: String
    let username: String
    let type: String
    let slug: String
    let url: String
    
    var image: UIImage? {
       didSet { self.onGifLoaded?() }
    }
    var isFavorite: Bool {
        didSet { onFavoriteStateChanged?(isFavorite) }
    }
    
    var onGifLoaded: (() -> Void)?
    var onFavoriteTapped: (() -> Void)?
    var onFavoriteStateChanged: ((Bool) -> Void)?
        
    init(id: String, gifURL: String, title: String, username: String, isFavorite: Bool, type: String, slug: String, url: String) {
        self.gifURL = gifURL
        self.title = title
        self.username = username
        self.id = id
        self.isFavorite = isFavorite
        self.type = type
        self.slug = slug
        self.url = url
    }
}
//MARK: - Logic
extension ItemTableviewCellVM {
    func loadImage() {
        guard let url = URL(string: gifURL), image == nil else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, let loadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = loadedImage
                }
            }
        }.resume()
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
        onFavoriteTapped?()
    }
}
