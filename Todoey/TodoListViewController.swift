//
//  ViewController.swift
//  Todoey
//
//  Created by Joy Paul on 12/10/18.
//  Copyright © 2018 Joy Paul. All rights reserved.
//

import UIKit

//since we are using the UITableViewController, we don't need to extend datasource and delegate
class TodoListViewController: UITableViewController {

    //the array for the todo list
    var itemArray = ["Find", "Them", "Stuff"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //configures the cell of the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //setting the text label inside the cell to itemarray
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    //returns how many items to be displayed in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //func to decide what happens when view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        //if the cell's accessory is set to a checkmark, set it to none
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        //if not, set accessory to a checkmark
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //animation when deselecting a row
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //a local var to store the input from the user
        var textField = UITextField()
        
        //creating an UIAlert
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        //creating an UIAlertAction
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //appending the value to the itemArray and then reloading tableView data
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
            
        }
        
        //adding an input box to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        
        }
        
        //adding the action to the alert
        alert.addAction(action)
        
        //presenting the alert with animation
        present(alert, animated: true, completion: nil)
    }
    

}

