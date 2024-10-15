//
//  RealmService.swift
//  ShopliveAssignment
//
//  Created by 윤형찬 on 10/15/24.
//

import RealmSwift

class RealmService {
    static let shared = RealmService()
    
    private init() {}
    
    func saveFavoriteCharacter(_ character: Character) -> Bool {
        let realm = try! Realm()
        
        let favoriteCount = realm.objects(RealmCharacter.self).count
        
        do {
            try realm.write {
                if favoriteCount >= 5 {
                    if let oldestCharacter = realm.objects(RealmCharacter.self).sorted(byKeyPath: "createdAt").first {
                        realm.delete(oldestCharacter)
                    }
                }
                
                let realmCharacter = RealmCharacter(character: character)
                realm.add(realmCharacter)
            }
            return true
        } catch {
            print("Error saving to Realm: \(error)")
            return false
        }
    }
    
    func removeFavoriteCharacter(_ character: Character) {
        let realm = try! Realm()
        if let realmCharacter = realm.object(ofType: RealmCharacter.self, forPrimaryKey: character.id) {
            do {
                try realm.write {
                    realm.delete(realmCharacter)
                }
            } catch {
                print("Error removing from Realm: \(error)")
            }
        }
    }
    
    func getFavoriteCharacters() -> [Character] {
        let realm = try! Realm()
        let realmCharacters = realm.objects(RealmCharacter.self).sorted(byKeyPath: "createdAt", ascending: true)
        return realmCharacters.map { $0.toCharacter() }
    }
    
    func isFavorite(_ character: Character) -> Bool {
        let realm = try! Realm()
        return realm.object(ofType: RealmCharacter.self, forPrimaryKey: character.id) != nil
    }
}
