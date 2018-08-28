//
//  EntryViewViewModelTests.swift
//  DiaryProjectTests
//
//  Created by 김종서 on 2018. 8. 27..
//  Copyright © 2018년 김종서. All rights reserved.
//

import XCTest
import Nimble
@testable import DiaryProject

class EntryViewViewModelTests: XCTestCase {
    func testHasEntry() {
        // setup
        let environment = Environment()
        let entry = Entry(text: "일기")
        
        // Run
        let viewModelWithEntry = EntryViewViewModel(environment: environment, entry: entry)
        let viewModelWithoutEntry = EntryViewViewModel(environment: environment)
        
        // Verify
        expect(viewModelWithEntry.hasEntry) == true
        expect(viewModelWithoutEntry.hasEntry) == false
    }
    
    func testTextViewText() {
        // setup
        let environment = Environment()
        let entry = Entry(text: "일기")
        
        // Run
        let viewModel = EntryViewViewModel(environment: environment, entry: entry)
        
        // Verify
        expect(viewModel.textViewText) == "일기"
    }
    
    func testTitleWhenEntryExists() {
        // setup
        let environment = Environment()
        let createdAt: Date = Date()
        let entry = Entry(createdAt: createdAt, text: "일기")
        
        // Run
        let viewModel = EntryViewViewModel(environment: environment, entry: entry)
        
        // verify
        expect(viewModel.title) == DateFormatter.entryDateFormatter.string(from: createdAt)
    }
    
    func testTitleWhenNoEntry() {
        // setup
        let now: Date = Date()
        let environment = Environment(now: { return now })
        
        // Run
        let viewModel = EntryViewViewModel(environment: environment)
        
        // verify
        expect(viewModel.title) == DateFormatter.entryDateFormatter.string(from: now)
    }
    
    func testRemoveButtonEnabledWhenEntryExists() {
        // setup
        let environment = Environment()
        let createdAt: Date = Date()
        let entry = Entry(createdAt: createdAt, text: "일기")
        
        // Run
        let viewModel = EntryViewViewModel(environment: environment, entry: entry)
        
        // verify
        expect(viewModel.removeButtonEnabled) == true
    }
    
    func testRemoveButtonEnabledWhenNoEntry() {
        // setup
        let environment = Environment()
        
        // Run
        let viewModel = EntryViewViewModel(environment: environment)
        
        // verify
        expect(viewModel.removeButtonEnabled) == false
    }
    
    func testUpdateOfEditingPropertiesWhenStartEdting() {
        // setup
        let environment = Environment()
        let viewModel = EntryViewViewModel(environment: environment)
        
        expect(viewModel.isEditing) == false
        expect(viewModel.textViewEditiable) == false
        expect(viewModel.buttonImage) == #imageLiteral(resourceName: "baseline_edit_white_24pt")
        
        // Run
        viewModel.startEditing()
        
        // verify
        expect(viewModel.isEditing) == true
        expect(viewModel.textViewEditiable) == true
        expect(viewModel.buttonImage) == #imageLiteral(resourceName: "baseline_save_white_24pt")
    }
    
    func testUpdateOfEditingPropertiesWhenECompleteEdting() {
        // setup
        let environment = Environment()
        let viewModel = EntryViewViewModel(environment: environment)
        
        viewModel.startEditing()
        
        expect(viewModel.isEditing) == true
        expect(viewModel.textViewEditiable) == true
        expect(viewModel.buttonImage) == #imageLiteral(resourceName: "baseline_save_white_24pt")
        
        // Run
        viewModel.completeEditing(with: "수정완료")
        
        // verify
        expect(viewModel.isEditing) == false
        expect(viewModel.textViewEditiable) == false
        expect(viewModel.buttonImage) == #imageLiteral(resourceName: "baseline_edit_white_24pt")

    }
    
    func testAddEntryToRepositoryWhenEntryPropertyIsNil() {
        // setup
        let repo = InMemoryEntryRepository()
        let environment = Environment(entryRepository: repo)
        let viewModel = EntryViewViewModel(environment: environment)
        
        // run
        viewModel.completeEditing(with: "일기 생성")
        
        //verify
        let entry = repo.recentEntries(max: 1).first
        expect(entry?.text) == "일기 생성"
    }
}
