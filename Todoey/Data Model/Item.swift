//
//  Item.swift
//  Todoey
//
//  Created by Joy Paul on 1/2/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date? //store the time and date an item is created. lazy init
    
    //inverse relationship
    //each item has an inverse relationship to a parentCategory from Category class named "items"
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
