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
    
    private var searchTask: DispatchWorkItem?
    
    func searchCharacters(nameStartsWith: String) {
        searchTask?.cancel()
        
        guard nameStartsWith.count >= 2 else {
            characters = []
            return
        }
        
        error = nil
        
        let task = DispatchWorkItem { [weak self] in
            MarvelAPI.shared.searchCharacters(nameStartsWith: nameStartsWith) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let characters):
                        self.characters = characters
                    case .failure(let error):
                        self.error = error
                        self.characters = []
                    }
                }
            }
        }
        
        searchTask = task
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
    }
}
