//
//  Foundation+MyDiary.swift
//  DiaryProject
//
//  Created by 김종서 on 2018. 8. 22..
//  Copyright © 2018년 김종서. All rights reserved.
//

import Foundation

extension DateFormatter{
    static var entryDateFormatter: DateFormatter = { () -> DateFormatter in
        let df = DateFormatter()
        df.dateFormat = "yyyy. MM. dd. EEE"
        return df
    }()
    
    static var entryTimeFormatter: DateFormatter = { () -> DateFormatter in
        let df = DateFormatter()
        df.dateFormat = "h:mm"
        return df
    }()
    
    static var ampmFormatter: DateFormatter = { () -> DateFormatter in
        let df = DateFormatter()
        df.dateFormat = "a"
        return df
    }()
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
