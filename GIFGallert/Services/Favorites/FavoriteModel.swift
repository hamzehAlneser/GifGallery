//
//  FavoriteModel.swift
//  GIFGallert
//
//  Created by Hamzeh on 09/08/2025.
//

struct FavoriteModel: Codable, Identifiable {
    let id: String
    let title: String
    let username: String
    let type: String
    let slug: String
    let url: String
    let imageURL: String
        
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
