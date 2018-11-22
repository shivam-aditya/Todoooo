//
//  ViewController.swift
//  Todoooo
//
//  Created by Shivam Aditya on 19/11/18.
//  Copyright © 2018 Shivam Aditya. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

//    let userDefaults = UserDefaults.standard
//    var itemArray = ["Find chotu", "Kill Boss", "Buy butcher knife for killing boss", "Torture him"]
    var itemArray = [Item]()
    let dbKey = "ToDoListArray"
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
        //loadItems()

        //tableView.register(UINib(nibName: "ToDoItemCell", bundle: nil), forCellReuseIdentifier: "toDoItemCell")
        //configureTableView()
        
//        let item1 = Item(context: self.viewContext)
//        item1.title = "Find chotu"
//        item1.done = true
//        itemArray.append(item1)
//
//        let item2 = Item(context: self.viewContext)
//        item2.title = "Kill Boss"
//        item2.done = false
//        itemArray.append(item2)
//
//        let item3 = Item(context: self.viewContext)
//        item3.title = "Buy butcher knife for killing boss"
//        item3.done = true
//        itemArray.append(item3)
//
//        let item4 = Item(context: self.viewContext)
//        item4.title = "Torture him"
//        item4.done = false
//        itemArray.append(item4)

//      UserDefaults CODE
//        if let itemsList = userDefaults.array(forKey: dbKey) as? [Item] {
//            itemArray = itemsList
//        }
    }
    
    func configureTableView () {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120.0
    }
    
    //MARK - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath) //as! CustomListCell
        
        let item = itemArray[indexPath.row]
        //cell.messageBody.text = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //FOR CORE DATA
        //itemArray[indexPath.row].setValue(!itemArray[indexPath.row].done, forKey: "done") //FOR CORE DATA

        // REMOVING DATA FROM CORE DATA
        //        viewContext.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)

        saveItemsToFile()

        tableView.deselectRow(at: indexPath, animated: true)
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
                
                //self.itemArray.append(itemToAdd)
                
                //let newItem = Item()
                let newItem = Item(context: self.viewContext)
                newItem.title = itemToAdd
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                
                self.saveItems()
                
                //self.configureTableView()
                self.tableView.reloadData()
            }
            
            //print(itemAddTextField.text)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Utility functions
    
    func saveItems(){
        //saveItemsToFile()
        saveItemsToCoreData()
    }
    
    func saveItemsToFile() {
//        self.userDefaults.set(self.itemArray, forKey: self.dbKey) //UserDefaults CODE
        
//        let encoder = PropertyListEncoder()  //CODABLE CODE
//
//        do {
//            let itemArrayEncodedData = try encoder.encode(itemArray)
//            try itemArrayEncodedData.write(to: dataFilePath!)
//        }
//        catch{
//            print("Error in saveItemsToFile in encoding item array is \(error)")
//        }
//
//        tableView.reloadData()
    }
    
    func saveItemsToCoreData() {
        do {
            try viewContext.save()
        }
        catch{
            print("Error in saveItemsToCoreData in encoding item array is \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(){
        //loadItemsFromFile()
        loadItemsFromCoreData()
    }
    
    func loadItemsFromCoreData(){
        if let itemsResponse = fetchDataFromDbByRequest() {
            itemArray = itemsResponse
            
            tableView.reloadData()
        }
        
//        if let selectedCategoryName = selectedCategory?.name {
//            let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//            request.predicate = NSPredicate(format: "parentCategory.name CONTAINS[cd] %@", selectedCategoryName)
//            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//            request.sortDescriptors = [sortDescriptor]
//
//            if let itemsResponse = fetchDataFromDbByRequest(with: request) {
//                itemArray = itemsResponse
//            }
//
//            tableView.reloadData()
//        }
    }
    
    func loadItemsFromFile(){
        //CODABLE CODE
//        do {
//            if let dataFromFile = try? Data(contentsOf: dataFilePath!){
//                let decoder = PropertyListDecoder()
//                itemArray = try decoder.decode([Item].self, from: dataFromFile)
//            }
//        } catch {
//            print("Error in loadItemsFromFile in decoding item array is \(error)")
//        }
    }
    
//    func fetchDataFromDbByRequest(with request: NSFetchRequest<Item> = Item.fetchRequest()) -> [Item]? {
//        do {
//            let itemsResponse = try viewContext.fetch(request)
//            return itemsResponse
//        } catch {
//            print("Error in fetchDataFromDbByRequest in decoding item array is \(error)")
//        }
//
//        return nil
//    }
    
    func fetchDataFromDbByRequest(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) -> [Item]? {
        do {
            if let selectedCategoryName = selectedCategory?.name {
                let categoryPredicate = NSPredicate(format: "parentCategory.name CONTAINS[cd] %@", selectedCategoryName)

                if let additionalPredicate = predicate {
                    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
                    request.predicate = compoundPredicate
                }
                else{
                    request.predicate = categoryPredicate
                }
                
                let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
                request.sortDescriptors = [sortDescriptor]
                
                let itemsResponse = try viewContext.fetch(request)
                return itemsResponse
            }
        } catch {
            print("Error in fetchDataFromDbByRequest in decoding item array is \(error)")
        }
        
        return nil
    }
}

//MARK - Search Bar Functionality

extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search Bar text is\(String(describing: searchBar.text))")

        if let searchText = searchBar.text {
//            let request : NSFetchRequest<Item> = Item.fetchRequest()
//            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ AND parentCategory.name CONTAINS[cd] %@", searchText, selectedCategoryName)
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)

            if let itemsResponse = fetchDataFromDbByRequest(predicate: predicate) {
                print(itemsResponse)
                
                itemArray = itemsResponse
                tableView.reloadData()
            }
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
