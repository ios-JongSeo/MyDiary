//
//  Entry.swift
//  DiaryProject
//
//  Created by 김종서 on 2018. 8. 3..
//  Copyright © 2018년 김종서. All rights reserved.
//

import Foundation

class Entry {
    let id: Int
    let createdAt: Date
    var text: String
    
    init(id: Int, createdAt: Date, text: String){
        self.id = id
        self.createdAt = createdAt
        self.text = text
    }
}
