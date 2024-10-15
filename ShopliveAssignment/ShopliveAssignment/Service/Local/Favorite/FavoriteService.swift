//
//  FavoriteService.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/15/24.
//

import Foundation

class FavoriteService {
    static let shared = FavoriteService()
    private let realmService = RealmService.shared
    
    @Published private(set) var favoriteCharacters: [Character] = []
    
    private init() {
        loadFavorites()
    }
    
    func loadFavorites() {
        favoriteCharacters = realmService.getFavoriteCharacters()
    }
    
    func isFavorite(_ character: Character) -> Bool {
        realmService.isFavorite(character)
    }
    
    func toggleFavorite(for character: Character) {
        if isFavorite(character) {
            realmService.removeFavoriteCharacter(character)
        } else {
            _ = realmService.saveFavoriteCharacter(character)
        }
        loadFavorites()
    }
}
