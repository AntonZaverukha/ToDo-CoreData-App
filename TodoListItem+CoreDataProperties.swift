//
//  TodoListItem+CoreDataProperties.swift
//  ToDo + CoreData
//
//  Created by Антон Заверуха on 23.02.2022.
//  Copyright © 2022 Антон Заверуха. All rights reserved.
//
//

import Foundation
import CoreData


extension TodoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoListItem> {
        return NSFetchRequest<TodoListItem>(entityName: "TodoListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?

}
