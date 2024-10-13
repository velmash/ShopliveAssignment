//
//  CharacterUseCase.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/13/24.
//

import Foundation

class MarvelAPI {
    static let shared = MarvelAPI()
    private let client = MarvelAPIClient()
    
    private init() {}
    
    func searchCharacters(nameStartsWith: String, completion: @escaping (Result<[Character], Error>) -> Void) {
        let endpoint = "/characters"
        let parameters = ["nameStartsWith": nameStartsWith]
        
        client.run(endpoint: endpoint, parameters: parameters) { (result: Result<MarvelResponse<Character>, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.data.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func cancelCurrentSearch() {
        client.cancelCurrentTask()
    }
}
