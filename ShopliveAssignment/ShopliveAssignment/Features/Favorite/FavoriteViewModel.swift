//
//  FavoriteViewModel.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/15/24.
//

import Foundation
import Combine

class FavoriteViewModel: FavoriteRepository {
    let favoriteService = FavoriteService.shared
    
    @Published var favoriteCharacters: [Character] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupFavoritesSubscription()
    }
    
    private func setupFavoritesSubscription() {
        favoritesPublisher
            .sink { [weak self] characters in
                self?.favoriteCharacters = characters
            }
            .store(in: &cancellables)
    }
}
