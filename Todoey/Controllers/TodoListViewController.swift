//
//  ViewController.swift
//  Todoey
//
//  Created by Joy Paul on 12/10/18.
//  Copyright © 2018 Joy Paul. All rights reserved.
//

import UIKit
import RealmSwift

//since we are using the UITableViewController, we don't need to extend datasource and delegate
class TodoListViewController: UITableViewController{

    //creating new realm
    let realm = try! Realm()
    
    //the array for the todo list
    var todoItems: Results<Item>?
    
    //everytime selected category var gets changed, loadItems gets called
    //diSet monitors when a variable gets changed
    //didset triggers loadItems()
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //loads the todo items
    func loadItems(){
        
        //todoItems gets called based on selected category's children items and are sorted by title in ascending order
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
        
    }
    
    
    //configures the cell of the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //if item isnt nil, set the cell.textLabel to title
        if let item = todoItems?[indexPath.row]{
            //setting the text label inside the cell to itemarray
            cell.textLabel?.text = item.title
            
            //if item.done is true chekmark on, if not, none
            cell.accessoryType = item.done == true ? .checkmark : .none
        }else {
            //if todoItems is nil, set label to this
            cell.textLabel?.text = "No items added"
        }
        
    return cell
        
    }
    
    
    //returns how many items to be displayed in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //func to decide what happens when view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(todoItems?[indexPath.row])
        
        //setting item.done property to be the opposite of what it currently is using the ream.write property
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write{
                    //realm.delete(item) would be used to delete an item
                    item.done = !item.done
                }
            } catch{
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        //animation for selection event
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //adding new todo items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //a local var to store the input from the user
        var textField = UITextField()
        
        //creating an UIAlert
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        //creating an UIAlertAction
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            //if currentcategory matches with the selected category
            if let currentcategory = self.selectedCategory{
                //do try write to realm
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        //appened items under current category
                        currentcategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving items")
                }
        }
            
        self.tableView.reloadData()
        
    }
    
        //adding an input box to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        //adding the action
        alert.addAction(action)
        
        //presenting
        present(alert, animated: true, completion: nil)
 
    }

}

/*
extension TodoListViewController: UISearchBarDelegate{
    //func to execute when search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //creating our request var so we can query and sort it
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)
        
        //querying data, searching for title that CONTAINS value. [cd] is case insensitive
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //sorting the request in ascending order
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
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
 
 */

