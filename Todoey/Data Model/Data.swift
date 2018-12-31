//
//  Data.swift
//  Todoey
//
//  Created by Joy Paul on 12/31/18.
//  Copyright © 2018 Joy Paul. All rights reserved.
//

import Foundation
import RealmSwift//for realm

//data class will be the data model for our realm database
class Data: Object {
    //for a var to be used with realm, they need to follow the below pattern
    //@objc dynamic var varName: varType = "default value"
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
