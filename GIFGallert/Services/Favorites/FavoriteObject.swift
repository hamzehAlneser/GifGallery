//
//  FavoriteObject.swift
//  GIFGallert
//
//  Created by Hamzeh on 10/08/2025.
//

import Foundation
import RealmSwift

final class FavoriteObject: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var slug: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var imageURL: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension FavoriteObject {
    convenience init(from model: FavoriteModel) {
        self.init()
        self.id = model.id
        self.title = model.title
        self.username = model.username
        self.type = model.type
        self.slug = model.slug
        self.url = model.url
        self.imageURL = model.imageURL
    }
    
    func toModel() -> FavoriteModel {
        FavoriteModel(
            id: id,
            title: title,
            username: username,
            type: type,
            slug: slug,
            url: url,
            imageURL: imageURL
        )
    }
}
