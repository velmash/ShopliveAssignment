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
    
    private var cancellables = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable?
    
    func searchCharacters(nameStartsWith: String) {
        // 이전 검색 취소
        searchCancellable?.cancel()
        
        guard nameStartsWith.count >= 2 else {
            return
        }
        
        error = nil
        
        let searchPublisher = MarvelAPI.shared.searchCharacters(nameStartsWith: nameStartsWith)
            .delay(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .share() //subscribe 공유
        
        searchCancellable = searchPublisher
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error
                    self?.characters = []
                case .finished:
                    break
                }
            } receiveValue: { [weak self] characters in
                self?.characters = characters
            }
        
        searchCancellable?.store(in: &cancellables)
    }
}
