//
//  TimelineViewContloller.swift
//  DiaryProject
//
//  Created by 김종서 on 2018. 8. 18..
//  Copyright © 2018년 김종서. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    @IBOutlet weak var entryCountLabel: UILabel!
    
    var environment: Environment!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "addEntry":
            let entryVC = segue.destination as? EntryViewController
            entryVC?.environment = environment
            
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "MyDiary"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let repository = environment.entryRepository
        
        entryCountLabel.text = repository.numberOfEntries > 0
        ? "엔트리 갯수: \(repository.numberOfEntries)"
        : "엔트리 없음"
    }
}
