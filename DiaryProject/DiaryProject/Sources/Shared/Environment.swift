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
    let now: () -> Date
    
    init(entryRepository: EntryRepository = InMemoryEntryRepository(),
        now: @escaping () -> Date = Date.init
        ) {
        self.entryRepository = entryRepository
        self.now = now
    }
}
