//
//  FavoritesCollectionViewCellVM.swift
//  GIFGallert
//
//  Created by Hamzeh on 10/08/2025.
//

import UIKit

final class FavoritesCollectionViewCellVM {
    let id: String
    let title: String
    let username: String
    let type: String
    let slug: String
    let url: String
    let imageURL: String
    
    var image: UIImage? {
       didSet { self.onGifLoaded?() }
    }
    
    var onGifLoaded: (() -> Void)?
    var onRemoveTapped: (() -> Void)?
        
    init(id: String, title: String, username: String, type: String, slug: String, url: String, imageURL: String) {
        self.id = id
        self.title = title
        self.username = username
        self.type = type
        self.slug = slug
        self.url = url
        self.imageURL = imageURL
    }
}
//MARK: - Logic
extension FavoritesCollectionViewCellVM {
    func loadImage() {
        guard let url = URL(string: imageURL), image == nil else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, let loadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = loadedImage
                }
            }
        }.resume()
    }
}
