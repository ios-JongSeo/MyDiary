//
//  ViewController.swift
//  DiaryProject
//
//  Created by 김종서 on 2018. 8. 2..
//  Copyright © 2018년 김종서. All rights reserved.
//

import UIKit
//import SnapKit

extension DateFormatter{
    static var entryDateFormatter:DateFormatter = {
        let df = DateFormatter.init()
        df.dateFormat = "yyyy. M. dd. EEE"
        return df
    }()
}

class ViewController: UIViewController {

    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var datelabel: UILabel!
    
    let journal: Journal = InMemoryJournal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textview.text = "뷰컨트롤러 텍스트"
        datelabel.text = DateFormatter.entryDateFormatter.string(from: Date())
    
    }

    @IBAction func saveEntry(_ sender: Any) {
        let entry: Entry = Entry(text: textview.text)
        journal.add(entry)
        print("Entry 개수: ", journal.numberOfEntries)
    }
    
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }


}

