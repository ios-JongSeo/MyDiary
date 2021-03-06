//
//  Identifiable.swift
//  DiaryProject
//
//  Created by 김종서 on 2018. 8. 4..
//  Copyright © 2018년 김종서. All rights reserved.
//

import Foundation

protocol Identifiable {
    var id: UUID { get }
}

extension Identifiable {
    func isIdentical(to other: Identifiable) -> Bool {
        return id == other.id
    }
}

