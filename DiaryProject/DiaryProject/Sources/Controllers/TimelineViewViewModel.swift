//
//  TimelineViewViewModel.swift
//  DiaryProject
//
//  Created by 김종서 on 2018. 8. 29..
//  Copyright © 2018년 김종서. All rights reserved.
//

import Foundation

class TimelineViewViewModel {
    let environment: Environment
    
    private var dates: [Date] = []
    private var entries: [Entry] {
        return environment.entryRepository.recentEntries(max: environment.entryRepository.numberOfEntries)
    }

    private func entries(for date: Date) -> [Entry] {
        return entries.filter { $0.createdAt.hmsRemoved == date }
    }

    private func entry(for indexPath: IndexPath) -> Entry {
        let date = dates[indexPath.section]
        let entriesOfDate = entries(for: date)
        let entry = entriesOfDate[indexPath.row]
        return entry
    }
    
    init(environment: Environment) {
        self.environment = environment
        dates = environment.entryRepository.uniqueDates
    }
    
    func removeEntry(at indexPath: IndexPath) {
        let date = dates[indexPath.section]
        let entries = self.entries(for: date)
        let entry = entries[indexPath.row]
        environment.entryRepository.remove(entry)
        
        if entries.count == 1 {
            dates = self.dates.filter { $0 != date }
        }
    }
    
    var newEntryViewViewModel: EntryViewViewModel {
        let vm = EntryViewViewModel(environment: environment)
        vm.delegate = self
        return vm
    }
    
    func entryViewViewModel(for indexPath: IndexPath) -> EntryViewViewModel {
        let vm = EntryViewViewModel(environment: environment, entry: entry(for: indexPath))
        vm.delegate = self
        return vm
    }
    
    func entryTableViewCellViewModel(for indexPath: IndexPath) -> EntryTableViewCellViewModel {
        let entry = self.entry(for: indexPath)
        
        return EntryTableViewCellViewModel(
            entryText: entry.text,
            timeText: DateFormatter.entryTimeFormatter.string(from: entry.createdAt),
            ampmText: DateFormatter.ampmFormatter.string(from: entry.createdAt)
        )
    }
}

extension TimelineViewViewModel {
    var numberOfSctions: Int { return dates.count }
    
    func title(for section: Int) -> String {
        let date = dates[section]
        return DateFormatter.entryDateFormatter.string(from: date)
    }
    
    func nuberOfRows(in section: Int) -> Int {
        let date = dates[section]
        return entries(for: date).count
    }
}

extension TimelineViewViewModel: EntryViewViewModelDelegate {
    func didAddEntry(_ entry: Entry) {
        dates = environment.entryRepository.uniqueDates
    }
    
    func didRemoveEntry(_ entry: Entry) {
        dates = environment.entryRepository.uniqueDates
    }
}

extension EntryRepository {
    var allEntries: [Entry] {
        return recentEntries(max: numberOfEntries)
    }
    
    var uniqueDates: [Date] {
        return allEntries
            .compactMap { $0.createdAt.hmsRemoved }
            .unique()
    }
}