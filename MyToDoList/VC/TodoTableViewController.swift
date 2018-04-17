//
//  TodoTableViewController.swift
//  MyToDoList
//
//  Created by MacBookPro on 2018. 4. 16..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

import UIKit
import CoreData
class TodoTableViewController: UITableViewController {
    //글쓰기 플로팅 버튼
    lazy var writeButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.8
        button.frame = CGRect(x: view.frame.width / 2 - 25, y: view.frame.height - 90 , width: 50, height: 50)
        button.layer.cornerRadius = button.frame.width/2
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.setBackgroundImage(#imageLiteral(resourceName: "pen.png"), for: UIControlState())
        button.addTarget(self, action: #selector(writeActionFlotingButton), for: .touchUpInside)
        return button
    }()
    //플로팅 액션 버튼
    @objc func writeActionFlotingButton(){
        performSegue(withIdentifier: "showAddTodo", sender: writeButton)
        

    }
    //propertis
    var resultsController: NSFetchedResultsController<Todo>!
    let coreDataStack = CoredataStack()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //요청
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: true)
        
        
        tableView.addSubview(writeButton)
        
        //초기화
        request.sortDescriptors = [sortDescriptors]
        resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack.managedContext , sectionNameKeyPath: nil, cacheName: nil)
        
        
        //resultcontroller에서 이벤트가 일어나면 이곳에서 반응해라
        resultsController.delegate = self
        
        do {
            try resultsController.performFetch()
        } catch  {
            print("perform fetch error : \(error)")
        }
        
        //네비게잉션 타이틀 바 폰트 사이즈
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.black,
             NSAttributedStringKey.font: UIFont(name: "NanumMyeongjoOTF-YetHangul", size: 21)!]
    
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.black,
             NSAttributedStringKey.font: UIFont(name: "NanumMyeongjoOTF-YetHangul", size: 30) ??
                UIFont.systemFont(ofSize: 30)]
       
        
        //네비게이션 바 색깔 변경
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        //테이블 배경 및 뒷배경 흰색 지정
        tableView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        tableView.backgroundView?.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "todoCell")
    }
    
    
    //글쓰기 플로팅 버튼 함수
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  off = self.tableView.contentOffset.y
        writeButton.frame = CGRect(x: view.frame.width / 2 - 25, y: off + (view.frame.height - 135), width: writeButton.frame.size.width, height: writeButton.frame.size.height)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        
       let cell =  UITableViewCell(style: .value1,
                        reuseIdentifier: "todoCell")
        
        cell.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        cell.contentView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        cell.textLabel?.font = UIFont(name: "NanumMyeongjoOTF-YetHangul", size: 17.0)
        let todo = resultsController.object(at: indexPath)
       
        print("중요도 - \(todo.priotity)")
        print("중요도 - \(todo.done)")
        
        if(todo.done){
          
            cell.textLabel?.text = "\(todo.title!)"
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (cell.textLabel?.text)!)
            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            cell.textLabel?.attributedText = attributeString
        }else{
            cell.textLabel?.text = "\(todo.title!)"
        }
        
        if(todo.priotity == 0){
            cell.detailTextLabel?.text = "☆"
            cell.detailTextLabel?.font = UIFont(name: "NanumMyeongjoOTF-YetHangul", size: 13.5)
        }else if(todo.priotity == 1){
            cell.detailTextLabel?.text = "☆☆"
            cell.detailTextLabel?.font = UIFont(name: "NanumMyeongjoOTF-YetHangul", size: 13.5)
        }else{
            cell.detailTextLabel?.text = "☆☆☆"
            cell.detailTextLabel?.font = UIFont(name: "NanumMyeongjoOTF-YetHangul", size: 13.5)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    //오른쪽에서 왼쪽으로 테이블 셀을 스와이프 했을 때
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "삭제") { (action, view, completion) in
            //코어데이터 삭제 로직
            let todo = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(todo)
            
            do{
                //삭제후 저장
                try self.resultsController.managedObjectContext.save()
                //완료
                completion(true)
            }catch{
                print("delete failed:\(error)")
                completion(false)
            }
            
        }
        action.image = #imageLiteral(resourceName: "ic_delete.png")
        action.backgroundColor = UIColor(red:0.88, green:0.56, blue:0.47, alpha:1.0)
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    //왼쪽에서 오른쪽으로 테이블 셀을 스와이프 했을 때
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "완료") { (action, view, completion) in
            //코어데이터 업데이트 로직
            let todo = self.resultsController.object(at: indexPath)
            
            if(todo.done){
                let title = tableView.cellForRow(at: indexPath)?.textLabel?.text
                tableView.cellForRow(at: indexPath)?.textLabel?.text = title
                todo.done = false
                tableView.reloadData()
            }else{
                let title = tableView.cellForRow(at: indexPath)?.textLabel?.text
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: title!)
                attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
                tableView.cellForRow(at: indexPath)?.textLabel?.attributedText = attributeString
                todo.done = true
                tableView.reloadData()
            }

            //self.resultsController.managedObjectContext.delete(todo)

            do{
                //업데이트 후 저장
                try self.resultsController.managedObjectContext.save()
                //완료
                completion(false)
            }catch{
                print("delete failed:\(error)")
                completion(false)
            }
            
            
            
        }
        

        tableView.reloadData()
        
        action.image = #imageLiteral(resourceName: "ic_done.png")
        action.backgroundColor = UIColor(red:0.77, green:0.88, blue:0.86, alpha:1.0)
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let todo = resultsController.object(at: indexPath)
        if(todo.done){
            return
        }
            
        
        performSegue(withIdentifier: "showAddTodo", sender: tableView.cellForRow(at: indexPath))
    }
    
    // MARK: - Navigation
    // 할일 추가할때 코어데이터 초기화 시켜준다.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        

        if let _ = sender as? UIButton, let vc = segue.destination as? AddTodoViewController{
            vc.managedContext = resultsController.managedObjectContext
        }
        
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? AddTodoViewController{
            vc.managedContext = resultsController.managedObjectContext
        }
        
        //할일 추가 페이지에 선택한 셀의 데이터 넣어주기
        if let cell = sender as? UITableViewCell, let vc = segue.destination as? AddTodoViewController{
            vc.managedContext = resultsController.managedObjectContext
            if let indexPath = tableView.indexPath(for: cell){
                let todo = resultsController.object(at: indexPath)
                vc.todo = todo
            }
        }
    }
}



extension TodoTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("controllerWillChangeContent")
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
         print("controllerDidChangeContent")
        tableView.endUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    //코어데이터에서 데이터 변경이 일어나면 이곳에서 바로 반응
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                print("NSFetched - insert \(indexPath.row)")
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete :
            if let indexPath = indexPath {
                print("NSFetched - delete \(indexPath.row)")
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
            }
        case .update :
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath){
                print("NSFetched - update")
                let todo = resultsController.object(at: indexPath)
                print("title - \(String(describing: todo.title))")
                cell.textLabel?.text = todo.title
            }
            
        default:
            break
        }
    }
    
}














