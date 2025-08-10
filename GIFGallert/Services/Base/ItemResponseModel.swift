//
//  ItemModel.swift
//  GIFGallert
//
//  Created by Hamzeh on 09/08/2025.
//

struct ItemResponseModel: Decodable {
    let id: String
    let title: String
    let images: Images
    let username: String
    let type: String
    let slug: String
    let url: String
}

struct Images: Decodable {
    let original: Original
}
struct Original: Decodable {
    let url: String
}


