//
//  API.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/13/24.
//

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
    
    func run<T: Codable>(endpoint: String, parameters: [String: String] = [:], completion: @escaping (Result<T, Error>) -> Void) {
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
            completion(.failure(NSError(domain: "URL 에러", code: 0, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "받은 데이터 없음", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    private func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
