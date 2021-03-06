//
//  RealmEntryRepository.swift
//  DiaryProject
//
//  Created by 김종서 on 2018. 9. 3..
//  Copyright © 2018년 김종서. All rights reserved.
//

import Foundation
import RealmSwift

class RealmEntryRepository: EntryRepository {
    private let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    var numberOfEntries: Int {
        return realm.objects(RealmEntry.self).count
    }
    
    func add(_ entry: EntryType) {
        guard let realmEntry = entry as? RealmEntry else { fatalError() }
        
        try! realm.write {
            realm.add(realmEntry)
        }
    }
    
    func update(_ entry: EntryType, text: String) {
        guard let realmEntry = entry as? RealmEntry else { fatalError() }
        
        try! realm.write {
            realmEntry.text = text
            realm.add(realmEntry, update: true)
        }
    }
    
    func remove(_ entry: EntryType) {
        guard let realmEntry = entry as? RealmEntry else { fatalError() }
        
        try! realm.write {
            realm.delete(realmEntry)
        }
    }
    
    func entries(contains string: String) -> [EntryType] {
        let result = realm.objects(RealmEntry.self)
            .filter("text CONTAINS[c] '\(string)'")
            .sorted(byKeyPath: "createdAt", ascending: false)
        
        return Array(result)
    }
    
    func entry(with id: UUID) -> EntryType? {
        return realm.objects(RealmEntry.self)
        .filter("uuidString == '\(id.uuidString)'")
        .first
    }
    
    func recentEntries(max: Int, page: Int, completion: @escaping([EntryType], Bool) -> ()) {
        let result = realm.objects(RealmEntry.self)
        .sorted(byKeyPath: "createdAt", ascending: false)
        .prefix(max)
        
        completion(Array(result), true)
    }
}
