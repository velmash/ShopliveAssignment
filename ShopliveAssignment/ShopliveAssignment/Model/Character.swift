//
//  Characters.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/13/24.
//

import Foundation

struct MarvelResponse<T: Codable>: Codable {
    let data: DataContainer<T>
}

struct DataContainer<T: Codable>: Codable {
    let results: [T]
}

struct Character: Codable {
    let id: Int
    let name, description: String
    let thumbnail: Thumbnail
}

struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}
