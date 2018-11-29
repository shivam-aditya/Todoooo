//
//  CategoryViewController.swift
//  Todoooo
//
//  Created by Shivam Aditya on 22/11/18.
//  Copyright © 2018 Shivam Aditya. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    var categoryArray : Results<Category>?
    let categoryTableCellIdentifier = "Cell"
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        tableView.separatorStyle = .none
    }
    
    //MARK: - Add new categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Category name"
        }
        
        let action = UIAlertAction(title: "Add category", style: .default) { (alertAction) in
            if let categoryToAddString = alert.textFields?[0].text {
                print("category added is is \(String(describing: categoryToAddString))")
                
                let categoryToAdd = Category()
            
                categoryToAdd.name = categoryToAddString
                categoryToAdd.backgroundColor = UIColor.randomFlat.hexValue()
                //self.categoryArray.append(categoryToAdd)
                
                self.saveData(item: categoryToAdd)
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Delete data from swipe
    
    override func deleteCell(at indexPath: IndexPath) {
        //handle action by updating model with deletion
        if let category = self.categoryArray?[indexPath.row]{
            do{
                try self.realm.write {
                    // REMOVING DATA FROM REALM
                    self.realm.delete(category)
                }
            }
            catch{
                print("Error in deleting category data from realm. Error is \(error)")
            }
        }
    }
}

extension CategoryViewController {
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let categoryItem = categoryArray?[indexPath.row]{
            cell.textLabel?.text = categoryItem.name
            
            guard let cellBackgroundColor = (categoryItem.backgroundColor != "" ? UIColor(hexString: categoryItem.backgroundColor) : UIColor.randomFlat) else{
                fatalError("cellBackgroundColor is null")
            }
            
            cell.backgroundColor = cellBackgroundColor
            cell.textLabel?.textColor = ContrastColorOf(cellBackgroundColor, returnFlat: true)
        }
        else{
            cell.textLabel?.text = "No categories added"
            cell.backgroundColor = UIColor.randomFlat
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print the category name that was tapped
        print("Category tapped is: \(String(describing: categoryArray?[indexPath.row].name))")
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToItems"){
            let destinationVC = segue.destination as! TodoListViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categoryArray?[indexPath.row]
            }
        }
    }
    

    //MARK: Data Manipulation Methods
    
    //save and load data
    func loadData(){
        loadItemsFromRealm()
    }
    
    func loadItemsFromRealm(){
        if let categoryItemsResponse = fetchAllDataFromRealm() {
            categoryArray = categoryItemsResponse
        }
    }
    
    func fetchAllDataFromRealm() -> Results<Category>? {
        let itemsResponse = realm.objects(Category.self)
        return itemsResponse
    }
    
    func saveData(item itemToBeSaved: Category){
        saveItemToRealm(item: itemToBeSaved)
    }
    
    func saveItemToRealm(item: Category) {
        do {
            try realm.write {
                realm.add(item)
            }
        }
        catch{
            print("Error in saveItemsToCoreData in encoding item array is \(error)")
        }
        
        tableView.reloadData()
    }
}
