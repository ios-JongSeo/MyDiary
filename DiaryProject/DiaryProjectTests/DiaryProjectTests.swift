//
//  DiaryProjectTests.swift
//  DiaryProjectTests
//
//  Created by 김종서 on 2018. 8. 3..
//  Copyright © 2018년 김종서. All rights reserved.
//

import XCTest
@testable import DiaryProject

extension Entry {
    static var dayBeforeYesterday: Entry { return Entry(id: 1, createdAt: Date.distantPast, text: "그저께 일기") }
    static var yesterDay: Entry { return Entry(id: 2, createdAt: Date(), text: "어제 일기") }
    static var today: Entry { return Entry(id: 3, createdAt: Date.distantFuture, text: "오늘 일기") }
}

class DiaryProjectTests: XCTestCase {
    // ....
    func testEditEntryText() {
        // Setup
        let entry = Entry(id: 0, createdAt: Date(), text: "첫 번째 일기") // Run
        
        // Run
        entry.text = "첫 번째 테스트"
        
        // Verify
        XCTAssertEqual(entry.text, "첫 번째 테스트")
        
    }
    
    func testAddEntryToJournal() {
        // Setup
        let journal = InMemoryJournal()
        let newEntry = Entry(id: 1, createdAt: Date(), text: "일기")

        // Run
        journal.add(newEntry)

        // Verify
        let entryInJournal: Entry? = journal.entry(with: 1)
        XCTAssertEqual(entryInJournal, .some(newEntry))
        XCTAssertTrue(entryInJournal === newEntry)
        XCTAssertTrue(entryInJournal?.isIdentical(to: newEntry) == true)
    }
    
    func testGetEntryWithId() {
        // Setup
        let oldEntry = Entry(id: 1, createdAt: Date(), text: "일기")
        let journal = InMemoryJournal(entries: [oldEntry])
        // Run
        let entry = journal.entry(with: 1)
        // Verify
        XCTAssertEqual(entry, .some(oldEntry))
        XCTAssertTrue(entry?.isIdentical(to: oldEntry) == true)
    }
    
    func testUpdateEntry(){
        //Setup
        let oldEntry = Entry(id: 1, createdAt: Date(), text: "일기")
        let journal = InMemoryJournal(entries: [oldEntry])
        
        //Run
        oldEntry.text = "일기 내용을 수정 했습니다."
        journal.update(oldEntry)
        
        //verify
        let entry = journal.entry(with: 1)
        XCTAssertEqual(entry, .some(oldEntry))
        XCTAssertTrue(entry?.isIdentical(to: oldEntry) == true)
        XCTAssertEqual(entry?.text, .some("일기 내용을 수정 했습니다."))
    }
    
    func testRemoveEntryFromJournal(){
        // Setup
        let oldEntry = Entry(id: 1, createdAt: Date(), text: "일기")
        let journal = InMemoryJournal(entries: [oldEntry])
        // Run
        journal.remove(oldEntry)
        // Verify
        let entry = journal.entry(with: 1)
        XCTAssertEqual(entry, nil)
    }
    
    func test_최근_순으로_엔트리를_불러올_수_있다() { // Setup
        let dayBeforeYesterday = Entry(id: 1, createdAt: Date.distantPast, text: "그저께 일기")
        let yesterDay = Entry(id: 2, createdAt: Date(), text: "어제 일기")
        let today = Entry(id: 3, createdAt: Date.distantFuture, text: "오늘 일기")
        let journal = InMemoryJournal(entries: [dayBeforeYesterday, yesterDay, today])
        // Run
        let entries = journal.recentEntries(max: 3)
        // Verify
        XCTAssertEqual(entries.count, 3)
        XCTAssertEqual(entries, [today, yesterDay, dayBeforeYesterday])
    }
    
    func test_요청한_엔트리의_수만큼_최신_순으로_반환한다() {
        // Setup
        let dayBeforeYesterday = Entry.dayBeforeYesterday
        let yesterDay = Entry.yesterDay
        let today = Entry.today
        
        let journal = InMemoryJournal(entries: [dayBeforeYesterday, yesterDay, today])
        
        // Run
        let entries = journal.recentEntries(max: 1)
        
        // Verify
        XCTAssertEqual(entries.count, 1)
        XCTAssertEqual(entries, [today])
    }
    
    func test_존재하는_엔트리보다_많은_수를_요청하면_존재하는_엔트리만큼만_반환한다() {
        // Setup
        let dayBeforeYesterday = Entry.dayBeforeYesterday
        let yesterDay = Entry.yesterDay
        let today = Entry.today
        
        let journal = InMemoryJournal(entries: [dayBeforeYesterday, yesterDay, today])
        
        // Run
        let entries = journal.recentEntries(max: 10)
        
        // Verify
        XCTAssertEqual(entries.count, 3)
        XCTAssertEqual(entries, [today, yesterDay, dayBeforeYesterday])
    }
}