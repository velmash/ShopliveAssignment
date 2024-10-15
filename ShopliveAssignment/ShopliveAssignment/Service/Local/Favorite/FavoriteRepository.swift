//
//  FavoriteManagable.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/15/24.
//

import Combine

protocol FavoriteRepository: AnyObject {
    var favoriteService: FavoriteService { get }
    var favoriteCharacters: [Character] { get set }
    var favoritesPublisher: AnyPublisher<[Character], Never> { get }
    
    func loadFavorites()
    func isFavorite(_ character: Character) -> Bool
    func toggleFavorite(for character: Character)
}

extension FavoriteRepository {
    var favoritesPublisher: AnyPublisher<[Character], Never> {
        favoriteService.$favoriteCharacters.eraseToAnyPublisher()
    }
    
    func loadFavorites() {
        favoriteService.loadFavorites()
    }
    
    func isFavorite(_ character: Character) -> Bool {
        favoriteService.isFavorite(character)
    }
    
    func toggleFavorite(for character: Character) {
        favoriteService.toggleFavorite(for: character)
    }
}
