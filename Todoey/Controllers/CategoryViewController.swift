//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Joy Paul on 12/24/18.
//  Copyright © 2018 Joy Paul. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
        
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
    
    // overriding the updateModel func and delete data from swipe
    override func updateModel(at indexPath: IndexPath){
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



