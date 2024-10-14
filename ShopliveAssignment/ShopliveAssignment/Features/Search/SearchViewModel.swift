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
    @Published private(set) var characters: [Character] = []
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
        
        MarvelAPI.shared.searchCharacters(nameStartsWith: currentSearchCharacterName, offset: currentOffset)
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
}
