//
//  FavoritesService.swift
//  GIFGallert
//
//  Created by Hamzeh on 09/08/2025.
//

import Foundation
import RealmSwift

final class FavoritesService {
    private let realm = try! Realm()
    
    func fetch() -> [FavoriteModel] {
        return realm.objects(FavoriteObject.self)
            .map { $0.toModel() }
    }
    
    func add(_ item: FavoriteModel) {
        guard !isFavorite(item.id) else { return }
        let object = FavoriteObject(from: item)
        try? realm.write {
            realm.add(object)
        }
    }
    
    func remove(id: String) {
        if let object = realm.object(ofType: FavoriteObject.self, forPrimaryKey: id) {
            try? realm.write {
                realm.delete(object)
            }
        }
    }
    
    func isFavorite(_ id: String) -> Bool {
        let realm = try! Realm()
        return realm.object(ofType: FavoriteObject.self, forPrimaryKey: id) != nil
    }
}
