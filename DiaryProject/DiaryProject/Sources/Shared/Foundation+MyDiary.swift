//
//  Foundation+MyDiary.swift
//  DiaryProject
//
//  Created by 김종서 on 2018. 8. 22..
//  Copyright © 2018년 김종서. All rights reserved.
//

import Foundation

extension DateFormatter{
    static func formatter(with format: String) -> DateFormatter {
        let df = DateFormatter()
        df.dateFormat = format
        return df
    }
    
    static var entryDateFormatter: DateFormatter = DateFormatter.formatter(with: "yyyy. MM. dd. EEE")
    static var entryTimeFormatter: DateFormatter = DateFormatter.formatter(with: "h:mm")
    static var ampmFormatter: DateFormatter = DateFormatter.formatter(with: "a")
}

extension Date {
    var hmsRemoved: Date? {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)
    }
    
    static func before(_ days: Int) -> Date {
        let timeInterval = Double(days) * 24 * 60 * 60
        return Date(timeIntervalSinceNow: -timeInterval)
    }
}

extension Array where Element: Hashable {
    func unique() -> [Element] {
        var result: [Element] = []
        var set: Set<Element> = []
        
        for item in self {
            if set.contains(item) == false {
                set.insert(item)
                result.append(item)
            }
        }
        return result
    }
}
