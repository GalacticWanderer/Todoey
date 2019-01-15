//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Joy Paul on 12/24/18.
//  Copyright © 2018 Joy Paul. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    //init a new realm
    let realm = try! Realm()
    
    //categoryArray now takes Results of Category items
    var categoryArray : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        tableView.rowHeight = 100.0
    }

    // tableView cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        //if text is nil, set to no categories set
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No catagories set"
        
        cell.delegate = self
        
        return cell
    }
    
    //tableView data count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //nil coalescing operator "?" -- "??"
        //if categoryArray isn't nil return count, else return 1
        return categoryArray?.count ?? 1
    }
    
    // save method
    func saveItems(category : Category){
        
        //using realm.write to save items
        do{
            try realm.write {
                realm.add(category)
            }
        } catch{
            print("Error saving item \(error)")
        }
        
        tableView.reloadData()
    }
    
    //load method
    func loadItems(){
        //setting categoryArray to Category realm objects
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
    //add new categories by using addButtonPressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            //**notice that there is no more appending of items since realm dynamically updates
            
            self.saveItems(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
}
    
    //on pressed, perform segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //gets executed before segue gets called
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        //checking to see 
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
        
        
}

//Swipe cell delegate method
//changed category tableview cell class to SwipTableViewCell and module to SwipeCellKit
extension CategoryViewController: SwipeTableViewCellDelegate{
    
    //left swipe to bring more options
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        //checking to see if swipe orientation is right, if not return nil
        guard orientation == .right else{return nil}
        
        let deletAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            //optional binding for category deletion
            //categoryForDeletion includes the item at categoryArray at indexPath.row
            if let categoryForDeletion = self.categoryArray?[indexPath.row]{
                
                //use realm.write to execute realm.delete
                do{
                    try self.realm.write{
                        self.realm.delete(categoryForDeletion)
                    }
                }
                catch {
                    print("Error deleting \(error)")
                }
                //tableView.reloadData() not needed if using editActionsOptionsForRowAt
            }
        }
        
        //briefly displays a placeholder image when deleted
        deletAction.image = UIImage(named: "delete")
        
        return [deletAction]
    }
    
    //func to enable left swipe to delete from SwipeCellKit
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions{
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        //options.transitionStyle = .border
        return options
    }
    
    
}

