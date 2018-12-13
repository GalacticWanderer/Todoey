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
    var itemArray = [Item]()
    
    //specifying a filepath for NSCoder to save the items to
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loading the items from plist to tableView on startup
       loadItems()
        
    }
    
    //configures the cell of the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //a var to hold itemArray indexpath
        let item = itemArray[indexPath.row]
        
        //setting the text label inside the cell to itemarray
        cell.textLabel?.text = item.title
        
        //if item.done is true chekmark on, if not, none
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
        
    }
    
    //returns how many items to be displayed in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //func to decide what happens when view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        //setting item.done as the opposite of what it currently is true/false
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //saves the items to the plist using NSCoder
        saveItems()
        
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
            let newItem = Item()
            newItem.title = textField.text!
            
            //appending new item
            self.itemArray.append(newItem)
            
            //saving the item after appending
            self.saveItems()
            
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

    //func to save data to our plist
    func saveItems(){
        //init variable encoder as PropertyListEncoder
        let encoder = PropertyListEncoder()
        
        //wrap the write op with do, catch and try
        do{
            let data = try encoder.encode(itemArray)//encode the item array
            try data.write(to: dataFilePath!)//erite to the filepath
        } catch{
            print("Error encoding item array")
        }
        
        //reloading tableview
        tableView.reloadData()
    }
    
    //func to load the data from plist
    func loadItems(){
        //'?' indicates optional and it's required
        if let data = try? Data(contentsOf: dataFilePath!){//retrieve the data path
            let decoder = PropertyListDecoder()//decoder variable
            
            //wrap the write op with do, catch and try
            do{
                //itemArray gets the decoded items
               itemArray = try decoder.decode([Item].self, from: data)
            }
            catch{
                print("Error decoding items")
            }
            
        }
    }

}

