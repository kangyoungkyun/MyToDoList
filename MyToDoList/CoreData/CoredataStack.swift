//
//  CoredataStack.swift
//  MyToDoList
//
//  Created by MacBookPro on 2018. 4. 16..
//  Copyright © 2018년 MacBookPro. All rights reserved.
//

import Foundation
import CoreData
//메인 시작점
class CoredataStack {
    
    //코어 데이터 콘테이너
    var container : NSPersistentContainer {
        print("container - NSPersistentContainer 호출")
        let container = NSPersistentContainer(name: "Todos")
        container.loadPersistentStores { (description, error) in
            guard error == nil else {
                print("error: \(error!)")
                return
            }
        }
        return container
    }
    
    //삽입,제거,수정담당?
    var managedContext: NSManagedObjectContext{
        print("managedContext - NSManagedObjectContext 호출")
        return container.viewContext
    }
}
