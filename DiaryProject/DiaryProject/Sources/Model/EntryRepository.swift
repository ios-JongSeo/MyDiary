//
//  Diary.swift
//  DiaryProject
//
//  Created by 김종서 on 2018. 8. 4..
//  Copyright © 2018년 김종서. All rights reserved.
//

import Foundation

protocol EntryRepository {
    var numberOfEntries: Int { get }
    
    func add(_ entry: EntryType)
    func update(_ entry: EntryType, text: String)
    func remove(_ entry: EntryType)
    func entry(with id: UUID) -> EntryType?
    func recentEntries(max: Int) -> [EntryType]

}

class InMemoryEntryRepository: EntryRepository {
    private var entries: [UUID: EntryType]
    
    init(entries: [Entry] = []) {
        var result: [UUID: Entry] = [:]
        
        entries.forEach { entry in
            result[entry.id] = entry
        }
        
        self.entries = result
    }
    
    static var shared: InMemoryEntryRepository = {
       let repository = InMemoryEntryRepository()
        return repository
    }()
    
    var numberOfEntries: Int {
        return entries.count
    }
    
    func add(_ entry: EntryType) {
        entries[entry.id] = entry
    }
    
    func update(_ entry: EntryType, text: String) {
        guard let entry = entry as? Entry else { fatalError() }
        entry.text = text
    }
    
    func remove(_ entry: EntryType) {
        entries[entry.id] = nil
    }
    
    func entry(with id: UUID) -> EntryType? {
        return entries[id]
    }
    
    func recentEntries(max: Int) -> [EntryType] {
        let result = entries
            .values
            .sorted { $0.createdAt > $1.createdAt  }
            .prefix(max)
        
        return Array(result)
    }
}
