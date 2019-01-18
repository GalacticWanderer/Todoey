//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Joy Paul on 1/16/19.
//  Copyright © 2019 Joy Paul. All rights reserved.
//

//class to inherit swipe cell abilities from
import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //tableView data source methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    //left swipe to bring more options
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        //checking to see if swipe orientation is right, if not return nil
        guard orientation == .right else{return nil}
        
        let deletAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.updateModel(at: indexPath)
           
        }
        
        //briefly displays a placeholder image when deleted
        deletAction.image = UIImage(named: "delete")
        
        return [deletAction]
    }
    
    //placeholder func to update data model which gets called on delete action
    func updateModel(at indexPath: IndexPath){
        
        
    }
    
    //func to enable left swipe to delete from SwipeCellKit
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions{
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        //options.transitionStyle = .border
        return options
    }
    
}

