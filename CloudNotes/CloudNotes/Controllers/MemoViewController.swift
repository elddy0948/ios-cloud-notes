//
//  MemoViewController.swift
//  CloudNotes
//
//  Created by 임성민 on 2021/02/16.
//
import CoreData
import UIKit

class MemoViewController: UIViewController {
    private let memoTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.dataDetectorTypes = .all
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private var tapGesture: UITapGestureRecognizer?
    var managedObjectContext: NSManagedObjectContext?
    var memo: Memo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(memoTextView)
        memoTextView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(didTapMoreButton))
        configureConstraints()
        registerKeyboardNotifications()
        configureGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        exitEditMode()
    }
    
    @objc func enterEditMode() {
        memoTextView.isEditable = true
        tapGesture?.isEnabled = false
        memoTextView.becomeFirstResponder()
    }
    
    @objc func exitEditMode() {
        memoTextView.isEditable = false
        tapGesture?.isEnabled = true
        memoTextView.resignFirstResponder()
    }
    
    @objc private func didTapMoreButton() {
        configureMoreAlert()
    }
    
    private func deleteMemo() {
        guard let memo = self.memo,
              let context = memo.managedObjectContext else {
            return
        }
        if context == self.managedObjectContext {
            context.delete(memo)
        }
        do {
            try self.managedObjectContext?.save()
        } catch let error as NSError {
            print("Delete Error: \(error), \(error.userInfo)")
        }
        let master = self.splitViewController as? MemoSplitViewController
        master?.memoTableViewController.popViewController(animated: true)
    }
}

// MARK:- Configure
extension MemoViewController {
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            memoTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            memoTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            memoTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    private func configureGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(enterEditMode))
        if let tapGesture = self.tapGesture {
            memoTextView.addGestureRecognizer(tapGesture)
        }
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(exitEditMode))
        swipeDownGesture.direction = UISwipeGestureRecognizer.Direction.down
        memoTextView.addGestureRecognizer(swipeDownGesture)
    }
    
    private func configureMoreAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share...", style: .default) { (_) in
            print("Share...")
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            let deleteAlertController = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
            let noAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { (_) in
                self.deleteMemo()
            }
            deleteAlertController.addAction(noAction)
            deleteAlertController.addAction(deleteAction)
            self.present(deleteAlertController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(shareAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func setMemo(_ memo: Memo) {
        memoTextView.text = memo.body
    }
}

// MARK:- Keyboard 관련
extension MemoViewController {
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeTextViewBottomInsetToKeyboardHeight), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetTextViewBottomInset), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func changeTextViewBottomInsetToKeyboardHeight(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height , right: 0)
        memoTextView.contentInset = contentInsets
    }
    
    @objc func resetTextViewBottomInset(_ notification: Notification) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        memoTextView.contentInset = contentInsets
    }
}

extension MemoViewController: UITextViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y > 0) {
            exitEditMode()
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
}
