//
//  DataModel.swift
//  Todoey
//
//  Created by Joy Paul on 12/13/18.
//  Copyright © 2018 Joy Paul. All rights reserved.
//

import Foundation

//item holds two vars, title and done
//class Item conforms to Codable protocol, which lets us encode and decode data
class Item: Codable{
    var title: String = ""
    var done: Bool = false
}
