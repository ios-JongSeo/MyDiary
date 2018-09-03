//
//  Environment.swift
//  DiaryProject
//
//  Created by 김종서 on 2018. 8. 20..
//  Copyright © 2018년 김종서. All rights reserved.
//

import Foundation

class Environment {
    let entryRepository: EntryRepository
    let entryFactory: (String) -> EntryType
    var settings: Settings
    let now: () -> Date
    
    init(entryRepository: EntryRepository = InMemoryEntryRepository(),
         entryFactory: @escaping (String) -> EntryType = { (text: String) -> EntryType in Entry(text: text) },
         settings: Settings = InMemorySettings(),
         now: @escaping () -> Date = Date.init
        ) {
        self.entryRepository = entryRepository
        self.entryFactory = entryFactory
        self.settings = settings
        self.now = now
    }
}
