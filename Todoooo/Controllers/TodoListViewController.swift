//
//  ViewController.swift
//  Todoooo
//
//  Created by Shivam Aditya on 19/11/18.
//  Copyright © 2018 Shivam Aditya. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

//    let userDefaults = UserDefaults.standard
//    var itemArray = ["Find chotu", "Kill Boss", "Buy butcher knife for killing boss", "Torture him"]
    var itemArray = [Item]()
    let dbKey = "ToDoListArray"
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //tableView.register(UINib(nibName: "ToDoItemCell", bundle: nil), forCellReuseIdentifier: "toDoItemCell")
        //configureTableView()
        
//        let item1 = Item()
//        item1.title = "Find chotu"
//        item1.done = true
//        itemArray.append(item1)
//
//        let item2 = Item()
//        item2.title = "Kill Boss"
//        item2.done = false
//        itemArray.append(item2)
//
//        let item3 = Item()
//        item3.title = "Buy butcher knife for killing boss"
//        item3.done = true
//        itemArray.append(item3)
//
//        let item4 = Item()
//        item4.title = "Torture him"
//        item4.done = false
//        itemArray.append(item4)
        
//        if let itemsList = userDefaults.array(forKey: dbKey) as? [Item] {
//            itemArray = itemsList
//        }
        
        loadItemsFromFile()
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
        print("Tapped item is \(itemArray[indexPath.row].title)")
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
        
        self.saveItemsToFile()
        
//        let selectedItem = itemArray[indexPath.row]
//        let cell = tableView.cellForRow(at: indexPath)
        
//        if let accessoryType = cell?.accessoryType {
//            if(accessoryType != .none){
//                cell?.accessoryType = .none
//                selectedItem.done = false
//            }
//            else{
//                cell?.accessoryType = .checkmark
//                selectedItem.done = true
//            }
//        }
//        else{
//            //not used
//            cell?.accessoryType = .checkmark
//            selectedItem.done = true
//        }
    }
    
    //MARK - Add new items
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        //var itemAddTextField = UITextField()

        let alert = UIAlertController(title: "Add new Todoooo item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            //itemAddTextField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //things to do once user adds the item
            if let itemToAdd = alert.textFields?[0].text {
                print("Success. text is \(String(describing: itemToAdd))")
                
                //self.itemArray.append(itemToAdd)
                let newItem = Item();
                newItem.title = itemToAdd
                self.itemArray.append(newItem)
                
                self.saveItemsToFile()
                
                //self.configureTableView()
                self.tableView.reloadData()
            }
            
            //print(itemAddTextField.text)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Utility functions
    
    func saveItemsToFile() {
        //self.userDefaults.set(self.itemArray, forKey: self.dbKey)
        let encoder = PropertyListEncoder()
        
        do{
            let itemArrayEncodedData = try encoder.encode(itemArray)
            try itemArrayEncodedData.write(to: dataFilePath!)
        }
        catch{
            print("Error in saveItemsToFile in encoding item array is \(error)")
        }
    }
    
    func loadItemsFromFile(){
        do {
            if let dataFromFile = try? Data(contentsOf: dataFilePath!){
                let decoder = PropertyListDecoder()
                
                itemArray = try decoder.decode([Item].self, from: dataFromFile)
            }
        } catch {
            print("Error in loadItemsFromFile in decoding item array is \(error)")
        }
    }
    
}

