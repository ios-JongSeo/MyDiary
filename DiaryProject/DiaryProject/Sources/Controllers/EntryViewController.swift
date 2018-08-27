//
//  ViewController.swift
//  DiaryProject
//
//  Created by 김종서 on 2018. 8. 2..
//  Copyright © 2018년 김종서. All rights reserved.
//
// branch add-navigation-controller

import UIKit
import SnapKit

protocol EntryViewControllerDelegate: class {
    func didRemoveEntry(_ entry: Entry)
}

class EntryViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var button: UIBarButtonItem!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    
    var viewModel: EntryViewViewModel!
    
    var environment: Environment!
    weak var delegate: EntryViewControllerDelegate?
    
    var journal: EntryRepository { return environment.entryRepository }
    var editingEntry: Entry?
    var hasEntry: Bool {
        return editingEntry != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date: Date = editingEntry?.createdAt ?? Date()
        
        textView.text = editingEntry?.text
        title = DateFormatter.entryDateFormatter.string(from: date)
        
        updateSubviews(for: hasEntry == false)
        
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
        
        //print("키보드 높이 : \(keyboardFrame.cgRectValue.height)")
        
        let isKeyboardWillShow: Bool = note.name == Notification.Name.UIKeyboardWillShow
        let keyboardHeight = isKeyboardWillShow ?
            keyboardFrame.cgRectValue.height
            : 0
        let animationOption = UIViewAnimationOptions.init(rawValue: curve)

        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            options: animationOption,
            animations: {
                self.textViewBottomConstraint.constant = -keyboardHeight
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if hasEntry == false {
            textView.becomeFirstResponder()
        }
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
        textView.resignFirstResponder()
    }
    
    @objc func editEntry(_ sender: Any){
        updateSubviews(for: true)
        textView.becomeFirstResponder()
    }
   
    @IBAction func removeEntry(_ sender: Any) {
        guard let entryToRemove = editingEntry else { return }
        
        let alertController = UIAlertController(
            title: "일기를 삭제 하시겠습니까??",
            message: "이 동작은 되돌릴 수 없습니다.",
            preferredStyle: .actionSheet
        )
        
        let removeAction: UIAlertAction = UIAlertAction(
            title: "삭제",
            style: .destructive) { (_) in
                self.environment.entryRepository.remove(entryToRemove)
                self.editingEntry = nil
        
                // pop
                self.delegate?.didRemoveEntry(entryToRemove)
        }
        alertController.addAction(removeAction)
        
        let cancelAction: UIAlertAction = UIAlertAction(
            title: "취소",
            style: .cancel,
            handler: nil
        )
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func updateSubviews(for isEditing: Bool) {
        textView.isEditable = true
        removeButton.isEnabled = hasEntry
        
        button.image = isEditing ? #imageLiteral(resourceName: "baseline_save_white_24pt") : #imageLiteral(resourceName: "baseline_edit_white_24pt")
        button.target = self
        button.action = isEditing
        ? #selector(saveEntry(_:))
        : #selector(editEntry(_:))
        
//        if isEditing{
//            textView.isEditable = true
//            textView.becomeFirstResponder()
//
//            button.image = #imageLiteral(resourceName: "baseline_save_white_24pt")
//            button.target = self
//            button.action = #selector(saveEntry(_:))
//        }else{
//            textView.isEditable = false // 저장 후 수정불가
//            textView.resignFirstResponder() // 키보드 숨기기
//
//            button.image = #imageLiteral(resourceName: "baseline_edit_white_24pt")
//            button.target = self
//            button.action = #selector(editEntry(_:))
//        }
    }

}

