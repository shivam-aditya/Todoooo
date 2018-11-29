//
//  ViewController.swift
//  Todoooo
//
//  Created by Shivam Aditya on 19/11/18.
//  Copyright © 2018 Shivam Aditya. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems : Results<Item>?
    let realm = try! Realm()
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchBar.delegate = self
    }
    
    func configureTableView () {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120.0
    }
    
    //MARK - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath) //as! CustomListCell
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                    
                    // REMOVING DATA FROM REALM
                    //realm.delete(item)
                }
            }
            catch{
                print("Error in didSelectRowAt in changing item done state to realm is \(error)")
            }
        }
        

        tableView.reloadData()
    }
    
    //MARK - Add new items
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        //var itemAddTextField = UITextField()

        let alert = UIAlertController(title: "Add new Todoooo item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Item name"
            //itemAddTextField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //things to do once user adds the item
            if let itemToAdd = alert.textFields?[0].text {
                print("Success. text is \(String(describing: itemToAdd))")
                
                if let currentCategory = self.selectedCategory{
                    
                    do{
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = itemToAdd
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                            //self.todoItems.append(newItem)
                        }
                    }
                    catch{
                        print("Error in AddButtonPressed in adding item to realm is \(error)")
                    }
                    
                    //self.saveItems(item: newItem)
                    
                    self.tableView.reloadData()
                }
            }
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Utility functions
    
    func saveItems(item itemToBeSaved: Item){
        saveItemToRealm(item: itemToBeSaved)
    }
    
    func saveItemToRealm(item: Item) {
        do {
            try realm.write {
                realm.add(item)
            }
        }
        catch{
            print("Error in saveItemToRealm in encoding item array is \(error)")
        }
        
        tableView.reloadData()
    }

    
    func loadItems(){
        //loadItemsFromFile()
        loadItemsFromCoreData()
    }
    
    func loadItemsFromCoreData(){
        if let itemsResponse = fetchDataFromDbByRequest() {
            todoItems = itemsResponse
            
            tableView.reloadData()
        }
    }
    

    
    func fetchDataFromDbByRequest() -> Results<Item>? {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        return todoItems
    }
}

//MARK - Search Bar Functionality

extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search Bar text is\(String(describing: searchBar.text))")

        if let searchText = searchBar.text {
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "dateCreated", ascending: true)
            
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.count == 0){
            loadItems()
            tableView.reloadData()
            
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
        }
    }
}
