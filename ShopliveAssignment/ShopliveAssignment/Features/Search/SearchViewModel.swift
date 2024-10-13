//
//  SearchViewModel.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/13/24.
//

import Foundation

class SearchViewModel {
    
    func searchAndPrintCharacters(nameStartsWith: String) {
        MarvelAPI.shared.searchCharacters(nameStartsWith: nameStartsWith) { result in
            switch result {
            case .success(let characters):
                for character in characters {
                    print("ID: \(character.id)")
                    print("Name: \(character.name)")
                    print("Description: \(character.description)")
                    print("Thumbnail: \(character.thumbnail.path).\(character.thumbnail.thumbnailExtension)")
                    print("---")
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}
