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
    @IBOutlet weak var button: UIButton!
    
    let journal: Journal = InMemoryJournal()
    private var editingEntry: Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = "Test"
        dateLabel.text = DateFormatter.entryDateFormatter.string(from: Date())
        
        button.addTarget(self, action: #selector(saveEntry(_:)), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder() // 키보드 보이기
    }
    
    @objc func saveEntry(_ sender: Any) {
        if let editing = editingEntry{
            editing.text = textView.text
            journal.update(editing)
        }else{
            let entry: Entry = Entry(text: textView.text)
            journal.add(entry)
            editingEntry = entry
        }
        
        updateSubviews(for: false)

    }
    
    @objc func editEntry(_ sender: Any){
        updateSubviews(for: true)
    }
    
    fileprivate func updateSubviews(for isEditing: Bool) {
        if isEditing{
            textView.isEditable = true
            textView.becomeFirstResponder()
            
            button.setTitle("저장", for: .normal)
            button.addTarget(self, action: #selector(saveEntry(_:)), for: .touchUpInside)
        }else{
            textView.isEditable = false // 저장 후 수정불가
            textView.resignFirstResponder() // 키보드 숨기기
            
            button.setTitle("수정", for: .normal)
            button.addTarget(self, action: #selector(editEntry(_:)), for: .touchUpInside)
        }
    }

}

