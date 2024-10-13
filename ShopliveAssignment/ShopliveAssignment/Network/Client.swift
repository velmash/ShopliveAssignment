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
    
    private var currentTask: URLSessionDataTask?
    
    init() {
        self.publicKey = Bundle.main.object(forInfoDictionaryKey: "PublicKey") as! String
        self.privateKey = Bundle.main.object(forInfoDictionaryKey: "PrivateKey") as! String
        self.baseURL = "https://gateway.marvel.com:443/v1/public"
    }
    
    func run<T: Codable>(endpoint: String, parameters: [String: String] = [:], completion: @escaping (Result<T, Error>) -> Void) {
        // 기존 태스크가 있다면 취소
        cancelCurrentTask()
        
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
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        LoadingIndicator.shared.show()
        currentTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            defer { self?.currentTask = nil }
            
            LoadingIndicator.shared.hide()
            
            if let error = error as NSError?, error.code == NSURLErrorCancelled {
                // 태스크가 취소된 경우
                return
            }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
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
        
        currentTask?.resume()
    }
    
    func cancelCurrentTask() {
        currentTask?.cancel()
        currentTask = nil
    }
    
    private func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
