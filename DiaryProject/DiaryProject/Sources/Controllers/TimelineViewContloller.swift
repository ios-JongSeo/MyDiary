//
//  TimelineViewContloller.swift
//  DiaryProject
//
//  Created by 김종서 on 2018. 8. 18..
//  Copyright © 2018년 김종서. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    
    var viewModel: TimelineViewViewModel!
    
//    var environment: Environment!
//
//    private var dates: [Date] = []
//    private var entries: [Entry] {
//        return environment.entryRepository.recentEntries(max: environment.entryRepository.numberOfEntries)
//    }
//
//    private func entries(for date: Date) -> [Entry] {
//        return entries.filter { $0.createdAt.hmsRemoved == date }
//    }
//
//    private func entry(for indexPath: IndexPath) -> Entry {
//        let date = dates[indexPath.section]
//        let entriesOfDate = entries(for: date)
//        let entry = entriesOfDate[indexPath.row]
//        return entry
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "addEntry":
            let entryVC = segue.destination as? EntryViewController
            entryVC?.viewModel = viewModel.newEntryViewViewModel
        
        case "showEntry":
            if
                let entryVC = segue.destination as? EntryViewController,
                let selectedIndexPath = tableview.indexPathForSelectedRow {
                entryVC.viewModel = viewModel.entryViewViewModel(for: selectedIndexPath)
            }
            
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MyDiary"
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableview.reloadData()
    }
}

extension TimelineViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSctions
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.title(for: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.nuberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "EntryTableViewCell", for: indexPath) as! EntryTableViewCell

        tableViewCell.viewModel = viewModel.entryTableViewCellViewModel(for: indexPath)
        return tableViewCell
    }
}

extension TimelineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  nil) { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            let isLastRowInSection = self.viewModel.nuberOfRows(in: indexPath.section) == 1
            self.viewModel.removeEntry(at: indexPath)
            
            UIView.animate(withDuration: 0.3) {
                
                tableView.beginUpdates()
                
                if isLastRowInSection {
                    
                    tableView.deleteSections(IndexSet.init(integer: indexPath.section), with: .automatic)
                    
                } else {
                    
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    
                }
                
                tableView.endUpdates()
            }
            
            success(true)
        }
        
        deleteAction.image = #imageLiteral(resourceName: "baseline_delete_white_24pt")
        deleteAction.backgroundColor = UIColor.gradientEnd
        
        return UISwipeActionsConfiguration(actions:
            [deleteAction]
        )
    }
}
