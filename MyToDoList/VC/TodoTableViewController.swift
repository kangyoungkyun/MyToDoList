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

    //propertis
    var resultsController: NSFetchedResultsController<Todo>!
    let coreDataStack = CoredataStack()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //요청
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: true)
        
        
        //초기화
        request.sortDescriptors = [sortDescriptors]
        resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack.managedContext , sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try resultsController.performFetch()
        } catch  {
            print("perform fetch error : \(error)")
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "todoCell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultsController.sections?[section].objects?.count ?? 0
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        let todo = resultsController.object(at: indexPath)
        cell.textLabel?.text = todo.title
        return cell
    }
 
    //오른쪽에서 왼쪽으로 테이블 셀을 스와이프 했을 때
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "삭제") { (action, view, completion) in
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "ic_delete.png")
        action.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    //왼쪽에서 오른쪽으로 테이블 셀을 스와이프 했을 때
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "완료") { (action, view, completion) in
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "ic_done.png")
        action.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
