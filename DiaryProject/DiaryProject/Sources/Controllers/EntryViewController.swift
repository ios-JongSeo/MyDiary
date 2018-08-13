//
//  ViewController.swift
//  DiaryProject
//
//  Created by 김종서 on 2018. 8. 2..
//  Copyright © 2018년 김종서. All rights reserved.
//
// branch 180811

import UIKit
import SnapKit

extension DateFormatter{
    static var entryDateFormatter: DateFormatter = { () -> DateFormatter in
        let df = DateFormatter()
        df.dateFormat = "yyyy. MM. dd. EEE"
        return df
    }()
}

class EntryViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    let journal: Journal = InMemoryJournal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = "Test"
        dateLabel.text = DateFormatter.entryDateFormatter.string(from: Date())
    }
    
    @IBAction func saveEntry(_ sender: Any) {
        let entry: Entry = Entry(text: textView.text)
        journal.add(entry)
        
        print("Entry 개수: ", journal.numberOfEntries)
    }

}

