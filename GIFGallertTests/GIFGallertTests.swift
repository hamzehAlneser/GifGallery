//
//  GIFGallertTests.swift
//  GIFGallertTests
//
//  Created by Hamzeh on 10/08/2025.
//

import Testing
import XCTest
@testable import GIFGallert
final class FavoritesViewModelTests: XCTestCase {
    
    var viewModel: FavoritesViewModel!
    var favoritsService = FavoritesService()
    override func setUp() {
        super.setUp()
        viewModel = FavoritesViewModel(favoritesService: favoritsService)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testAddingToFavorites() {
        let item = FavoriteModel(
            id: "abc123",
            title: "Dancing Cat",
            username: "catlover",
            type: "gif",
            slug: "dancing-cat-abc123",
            url: "https://giphy.com/gifs/dancing-cat-abc123",
            imageURL: "https://media.giphy.com/media/abc123/giphy.gif"
        )
        
        favoritsService.add(item)
        

        XCTAssertTrue(favoritsService.fetch().contains(where: { $0.id == item.id }))
    }
    
    func testRemovingFromFavorites() {
        let item = FavoriteModel(
            id: "abc123",
            title: "Dancing Cat",
            username: "catlover",
            type: "gif",
            slug: "dancing-cat-abc123",
            url: "https://giphy.com/gifs/dancing-cat-abc123",
            imageURL: "https://media.giphy.com/media/abc123/giphy.gif"
        )
        
        XCTAssertFalse(favoritsService.fetch().contains(where: { $0.id == item.id }))
    }
}
