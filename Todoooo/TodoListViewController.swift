//
//  ViewController.swift
//  Todoooo
//
//  Created by Shivam Aditya on 19/11/18.
//  Copyright © 2018 Shivam Aditya. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let defaults = UserDefaults.standard
    var itemArray = ["Find chotu", "Kill Boss", "Buy butcher knife for killing boss", "Torture him"]
    let dbKey = "ToDoListArray"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //tableView.register(UINib(nibName: "ToDoItemCell", bundle: nil), forCellReuseIdentifier: "toDoItemCell")
        
        //configureTableView()
        
        if let itemsList = defaults.array(forKey: dbKey) as? [String] {
            itemArray = itemsList
        }
    }
    
    func configureTableView () {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120.0
    }
    
    //MARK - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath) //as! CustomListCell
        
        //cell.messageBody.text = itemArray[indexPath.row]
        cell.textLabel?.text = itemArray[indexPath.row]
        
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
        print("Tapped item is \(itemArray[indexPath.row])")
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if let accessoryType = cell?.accessoryType {
            if(accessoryType != .none){
                cell?.accessoryType = .none
            }
            else{
                cell?.accessoryType = .checkmark
            }
        }
        else{
            //not used
            cell?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
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
                
                self.itemArray.append(itemToAdd)
                self.defaults.set(self.itemArray, forKey: self.dbKey)
                
                //self.configureTableView()
                self.tableView.reloadData()
            }
            
            //print(itemAddTextField.text)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}

