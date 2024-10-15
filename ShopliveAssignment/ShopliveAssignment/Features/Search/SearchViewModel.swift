//
//  SearchViewModel.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/13/24.
//

import Foundation
import Combine

// ViewModel
class SearchViewModel {
    let remoteUseCase = MarvelAPI.shared
    let localUseCase = RealmService.shared
    
    @Published private(set) var characters: [Character] = []
    @Published private(set) var favoriteCharacters: Set<Int> = []
    
    @Published private(set) var error: Error?
    @Published private(set) var isLoading = false
    
    private var currentOffset = 0
    private let limit = 10
    private var currentSearchCharacterName = ""
    private var canLoadMore = true
    
    private var cancellables = Set<AnyCancellable>()
    
    let searchSubject = PassthroughSubject<String, Never>()
    
    init() {
        setupSearchDebounce()
    }
    
    func loadFavorites() {
        favoriteCharacters = Set(localUseCase.getFavoriteCharacters().map { $0.id })
    }
    
    private func setupSearchDebounce() {
        searchSubject
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.searchCharacters(nameStartsWith: searchText)
            }
            .store(in: &cancellables)
    }
    
    private func searchCharacters(nameStartsWith: String) {
        guard nameStartsWith.count >= 2 else {
            characters = []
            return
        }
        
        currentSearchCharacterName = nameStartsWith
        currentOffset = 0
        canLoadMore = true
        characters = []
        
        loadMoreCharacters()
    }
    
    func loadMoreCharacters() {
        guard !isLoading, canLoadMore else { return }
        
        isLoading = true
        
        remoteUseCase.searchCharacters(nameStartsWith: currentSearchCharacterName, offset: currentOffset)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] newCharacters in
                guard let self = self else { return }
                self.characters.append(contentsOf: newCharacters)
                self.currentOffset += newCharacters.count
                self.canLoadMore = newCharacters.count == self.limit
            }
            .store(in: &cancellables)
    }
    
    func isFavoriteCharacter(_ character: Character) -> Bool {
        favoriteCharacters.contains(character.id)
    }
    
    func toggleFavorite(for character: Character) {
        if favoriteCharacters.contains(character.id) {
            removeFavorite(character)
        } else {
            addFavorite(character)
        }
    }
    
    private func removeFavorite(_ character: Character) {
        localUseCase.removeFavoriteCharacter(character)
        favoriteCharacters.remove(character.id)
    }
    
    private func addFavorite(_ character: Character) {
        if localUseCase.saveFavoriteCharacter(character) {
            favoriteCharacters.insert(character.id)
        }
    }
}
