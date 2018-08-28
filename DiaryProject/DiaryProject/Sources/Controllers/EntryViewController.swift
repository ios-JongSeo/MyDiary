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
    weak var delegate: EntryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        textView.text = viewModel.textViewText
        
        updateSubviews(for: viewModel.hasEntry == false)
        
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
        if viewModel.hasEntry == false {
            textView.becomeFirstResponder()
        }
    }
    
    @objc func saveEntry(_ sender: Any) {
        viewModel.completeEditing(with: textView.text)
        updateSubviews(for: false)
        textView.resignFirstResponder()
    }
    
    @objc func editEntry(_ sender: Any){
        viewModel.startEditing()
        updateSubviews(for: true)
        textView.becomeFirstResponder()
    }
   
    @IBAction func removeEntry(_ sender: Any) {
        guard viewModel.hasEntry else { return }
        
        let alertController = UIAlertController(
            title: "일기를 삭제 하시겠습니까??",
            message: "이 동작은 되돌릴 수 없습니다.",
            preferredStyle: .actionSheet
        )
        
        let removeAction: UIAlertAction = UIAlertAction(
            title: "삭제",
            style: .destructive) { (_) in
                guard
                let removedEntry = self.viewModel.removeEntry()
                    else { return }
                // pop
                self.delegate?.didRemoveEntry(removedEntry)
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
        textView.isEditable = viewModel.textViewEditiable
        removeButton.isEnabled = viewModel.removeButtonEnabled
        
        button.image = viewModel.buttonImage
        button.target = self
        button.action = viewModel.isEditing
        ? #selector(saveEntry(_:))
        : #selector(editEntry(_:))
    }

}

