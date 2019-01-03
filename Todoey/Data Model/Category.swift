//
//  Category.swift
//  Todoey
//
//  Created by Joy Paul on 1/2/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    
    //forward relationship
    //items has 1:M relationship with a list of items
    let items = List<Item>()
}
