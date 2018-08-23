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
