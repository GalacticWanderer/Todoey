//
//  ViewController.swift
//  Todoey
//
//  Created by Joy Paul on 12/10/18.
//  Copyright © 2018 Joy Paul. All rights reserved.
//

import UIKit
import CoreData

//since we are using the UITableViewController, we don't need to extend datasource and delegate
class TodoListViewController: UITableViewController{

    //the array for the todo list
    var itemArray = [Item]()
    
    //CoreData
    //context takes gets the singleton shared delegate of UIApp and brings to our AppDelegate and then taps into it's persistent container and then grabs the viewcontext of it
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
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
        
        /*
         *** deleting an item from tableView and database
         * context.delete(array[indexPath.row]) must be called first before
         * array.remove(at: indexPath.row)
         
         code below:
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
         */
        
        //once bool is changed on tap, updates the stored value on CoreData by calling saveItems() method
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
            
            //init newItem using the Item and the context we declared before
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
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

    //func to save/update data to CoreData
    func saveItems(){
     
        do{
            try context.save()
        } catch{
            print("error saving context \(error)")
        }
        
        //reloading tableview
        tableView.reloadData()
    }
    
    //func to load the data from CoreData
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        //loaditems take a param request of type NSFetchRequest which has a default value of Item.fetchRequest() if no param passed
        
            //wrap the write op with do, catch and try
            do{
                //setting the itemArray to the contents of the fetch request
                //pass request we declared before
                itemArray = try context.fetch(request)
            }
            catch{
               print("Error loading data \(error)")
            }
        tableView.reloadData()
        }
}


extension TodoListViewController: UISearchBarDelegate{
    //func to execute when search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //creating our request var so we can query and sort it
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)
        
        //querying data, searching for title that CONTAINS value. [cd] is case insensitive
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //sorting the request in ascending order
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
    }
    
    //func to detect when text changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //if textCount of search button is 0
        //loaditem() the original table
        //let go of the serachBar by resigning it from the first responder
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async{
                searchBar.resignFirstResponder()
            }
        }
    }
    
}



