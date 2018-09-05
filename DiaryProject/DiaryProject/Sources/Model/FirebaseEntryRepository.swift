//
//  FirebaseEntryRepository.swift
//  DiaryProject
//
//  Created by 김종서 on 2018. 9. 4..
//  Copyright © 2018년 김종서. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseEntryRepository: EntryRepository {
    private let reference: DatabaseReference
    
    init(reference: DatabaseReference = Database.database().reference()) {
        self.reference = reference.child("entries")
    }
    
    var numberOfEntries: Int { return 0 }
    
    func add(_ entry: EntryType) {
        reference.child(entry.id.uuidString).setValue(entry.toDictionary())
    }
    
    func update(_ entry: EntryType, text: String) {
    
    }
    
    func remove(_ entry: EntryType) {
    
    }
    
    func entries(contains string: String) -> [EntryType] {
        return []
    }
    
    func entry(with id: UUID) -> EntryType? {
        return nil
    }
    
    func recentEntries(max: Int) -> [EntryType] {
        return []
    }
}
