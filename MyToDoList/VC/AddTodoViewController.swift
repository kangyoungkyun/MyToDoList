//
//  AddTodoViewController.swift
//  MyToDoList
//
//  Created by MacBookPro on 2018. 4. 16..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

import UIKit
import CoreData
class AddTodoViewController: UIViewController {
    
    //properties
    var managedContext: NSManagedObjectContext!
    
    
    var todo: Todo?
    
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
        //키보드 자동 나타나기
        textView.becomeFirstResponder()
        //할일 목록 테이블 뷰에서 넣어준 데이터 넣어주기
        if let todo = todo{
            textView.text = todo.title
            segmentedControl.selectedSegmentIndex = Int(todo.priotity)
            textView.text = todo.title
        }
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
        //키보드 자동 사라지기
        textView.resignFirstResponder()
    }
    
    //저장
    @IBAction func done(_ sender: UIButton) {
        guard let title = textView.text, !title.isEmpty else{
            return
        }
        //테이블 뷰에서 넘겨준 데이터가 있으면 수정이고
        if let todo = self.todo{
            todo.title = title
            
            todo.priotity = Int16(segmentedControl.selectedSegmentIndex)
        }else{
            //없다면 추가
            let todo = Todo(context: managedContext)
            todo.title = title
            todo.priotity = Int16(segmentedControl.selectedSegmentIndex)
            todo.date = Date()
        }
        
        
        
        do {
            try managedContext.save()
            dismiss(animated: true, completion: nil)
            textView.resignFirstResponder()
        } catch  {
            print("error saving todo: \(error)")
        }
    }
    
}




extension AddTodoViewController: UITextViewDelegate {
    //텍스트 뷰에 변화가 일어났을때 작동하는 함수
    func textViewDidChangeSelection(_ textView: UITextView) {
        //게다가 완료 버튼이 숨겨져 있다면
        if doneButton.isHidden {
            //모든 텍스트를 지우고, 글꼴은 흰색으로
            textView.text.removeAll()
            textView.textColor = .white
            //완료버튼 보이게!
            doneButton.isHidden = false
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
}














