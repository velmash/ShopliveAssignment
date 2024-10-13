//
//  CharacterUseCase.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/13/24.
//

import Foundation
import Combine

class MarvelAPI {
    static let shared = MarvelAPI()
    private let client = MarvelAPIClient()
    
    private init() {}
    
    func searchCharacters(nameStartsWith: String) -> AnyPublisher<[Character], Error> {
        let endpoint = "/characters"
        let parameters = ["nameStartsWith": nameStartsWith]
        
        return client.run(endpoint: endpoint, parameters: parameters)
            .map { (response: MarvelResponse<Character>) in
                response.data.results
            }
            .eraseToAnyPublisher()
    }
}
