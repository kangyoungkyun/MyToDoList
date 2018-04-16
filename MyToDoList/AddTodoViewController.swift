//
//  AddTodoViewController.swift
//  MyToDoList
//
//  Created by MacBookPro on 2018. 4. 16..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

import UIKit

class AddTodoViewController: UIViewController {

    //텍스트뷰 객체
    @IBOutlet weak var textView: UITextView!
    //세그먼트 객체
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    //완료버튼
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // 키보드 설정.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(with:)),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
        
    }

    
    @objc func keyboardWillShow(with notification: Notification){
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height + 16// 키보드 높이
        //키보드가 올라오는 높이 만큼 스택뷰 바닥 설정 해주기
        bottomConstraint.constant = keyboardHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //취소
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIButton) {
    }
    
}
