//
//  ViewController.swift
//  DiaryProject
//
//  Created by 김종서 on 2018. 8. 2..
//  Copyright © 2018년 김종서. All rights reserved.
//

import UIKit
import SnapKit

extension DateFormatter{
    static var entryDateFormatter: DateFormatter = { () -> DateFormatter in
        let df = DateFormatter()
        df.dateFormat = "yyyy. MM. dd. EEE"
        return df
    }()
}

let code = """
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
"""

class EntryViewController: UIViewController {
    
    let journal: Journal = InMemoryJournal()
    private var editingEntry: Entry?
    
    var yellowViewHeight: Constraint!
//    var mainTextViewBottom: Constraint!
    
    lazy var yellowView: UIView = {
       var view = UIView()
        view.backgroundColor = UIColor.yellow
        return view
    }()
    
    lazy var datelabel: UILabel = {
        var label = UILabel()
        label.text = DateFormatter.entryDateFormatter.string(from: Date())
        return label
    }()
    
    lazy var saveButton: UIButton = {
        var button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        return button
    }()
    
    lazy var mainTextView: UITextView = {
        var textView = UITextView()
        textView.text = code
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(yellowView)
        yellowView.snp.makeConstraints { (m) in
            m.width.equalTo(view)
            m.height.equalTo(100)
            m.top.equalTo(view).offset(20)
            
            yellowViewHeight = m.height.equalTo(100).constraint
        }
        
        yellowView.addSubview(datelabel)
        datelabel.snp.makeConstraints{ (m) in
            m.width.equalTo(150)
            m.height.equalTo(20)
            m.bottom.equalTo(yellowView).offset(-10)
            m.left.equalTo(yellowView).offset(10)
        }
        
        yellowView.addSubview(saveButton)
        saveButton.snp.makeConstraints{ (m) in
            m.width.equalTo(50)
            m.height.equalTo(20)
            m.bottom.equalTo(yellowView).offset(-10)
            m.right.equalTo(yellowView).offset(-10)
        }
        
        datelabel.center.y = saveButton.center.y
        
        view.addSubview(mainTextView)
        mainTextView.snp.makeConstraints { (m) in
            m.width.equalTo(view)
            m.height.equalTo(view)
            m.top.equalTo(yellowView.snp.bottom).offset(5)
            
//            mainTextViewBottom = m.bottom.equalToSuperview().constraint
        }
        
        saveButton.addTarget(self, action: #selector(saveEntry(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlekeyboardAppearance(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlekeyboardAppearance(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handlekeyboardAppearance(_ note: Notification){
        guard
            let userInfo = note.userInfo,
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue),
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval),
            let curve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt)
            else{ return }

        let isKeyboardWillShow: Bool = note.name == Notification.Name.UIKeyboardWillShow
//        let keyboardHeight = isKeyboardWillShow
        _ = isKeyboardWillShow
            ? keyboardFrame.cgRectValue.height
            : 0
        let animationOption = UIViewAnimationOptions.init(rawValue: curve)
        let yellowHeight = isKeyboardWillShow ? 100 : 50

        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            options: animationOption,
            animations: {
//                self.mainTextViewBottom.update(offset: -keyboardHeight)
                self.yellowViewHeight.update(offset: yellowHeight)
                self.view.layoutIfNeeded()
        },
            completion: nil
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainTextView.becomeFirstResponder()
    }

    @objc func saveEntry(_ sender: Any){
        if let editing = editingEntry {
            editing.text = mainTextView.text
            journal.update(editing)
        }else{
            let entry: Entry = Entry(text: mainTextView.text)
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
            mainTextView.isEditable = true
            mainTextView.becomeFirstResponder()

            saveButton.setTitle("저장", for: .normal)
            saveButton.removeTarget(self, action: nil, for: .touchUpInside)
            saveButton.addTarget(self, action: #selector(saveEntry(_:)), for: .touchUpInside)
        }else{
            mainTextView.isEditable = false // 저장 후 수정불가
            mainTextView.resignFirstResponder() // 키보드 숨기기

            saveButton.setTitle("수정", for: .normal)
            saveButton.removeTarget(self, action: nil, for: .touchUpInside)
            saveButton.addTarget(self, action: #selector(editEntry(_:)), for: .touchUpInside)
        }
    }

}

