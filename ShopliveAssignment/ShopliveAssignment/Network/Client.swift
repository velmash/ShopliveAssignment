//
//  API.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/13/24.
//

import Combine
import Foundation
import CryptoKit

// 공통 API 클라이언트
class MarvelAPIClient {
    let publicKey: String
    let privateKey: String
    let baseURL: String
    
    init() {
        self.publicKey = Bundle.main.object(forInfoDictionaryKey: "PublicKey") as! String
        self.privateKey = Bundle.main.object(forInfoDictionaryKey: "PrivateKey") as! String
        self.baseURL = "https://gateway.marvel.com:443/v1/public"
    }
    
    func run<T: Codable>(endpoint: String, parameters: [String: String] = [:]) -> AnyPublisher<T, Error> {
        let timestamp = String(Date().timeIntervalSince1970)
        let hash = MD5(string: timestamp + privateKey + publicKey)
        
        var components = URLComponents(string: baseURL + endpoint)
        var queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        queryItems += [
            URLQueryItem(name: "apikey", value: publicKey),
            URLQueryItem(name: "ts", value: timestamp),
            URLQueryItem(name: "hash", value: hash)
        ]
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            return Fail(error: NSError(domain: "Invalid URL", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
        
        LoadingIndicator.shared.show()
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                LoadingIndicator.shared.hide()
                
                guard let httpResponse = response as? HTTPURLResponse,
                      200...299 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
