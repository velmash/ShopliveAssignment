//
//  RealmCharacter.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/15/24.
//

import RealmSwift

// DB 모델링
class RealmCharacter: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var characterDescription: String
    @Persisted var thumbnailPath: String
    @Persisted var thumbnailExtension: String
    
    convenience init(character: Character) {
        self.init()
        self.id = character.id
        self.name = character.name
        self.characterDescription = character.description
        self.thumbnailPath = character.thumbnail.path
        self.thumbnailExtension = character.thumbnail.thumbnailExtension
    }
    
    func toCharacter() -> Character {
        return Character(
            id: id,
            name: name,
            description: characterDescription,
            thumbnail: Thumbnail(path: thumbnailPath, thumbnailExtension: thumbnailExtension)
        )
    }
}
