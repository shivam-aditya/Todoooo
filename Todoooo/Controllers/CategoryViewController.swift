//
//  CategoryViewController.swift
//  Todoooo
//
//  Created by Shivam Aditya on 22/11/18.
//  Copyright © 2018 Shivam Aditya. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    var categoryArray = [Category]()
    let persistentContainerViewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let categoryTableCellIdentifier = "CategoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        loadData()
    }
    
    //MARK: - Add new categories

    @IBAction func addButtonpressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Category name"
        }
        
        let action = UIAlertAction(title: "Add category", style: .default) { (alertAction) in
            if let categoryToAddString = alert.textFields?[0].text {
                print("category added is is \(String(describing: categoryToAddString))")
                
                let categoryToAdd = Category(context: self.persistentContainerViewContext)
            
                categoryToAdd.name = categoryToAddString
                self.categoryArray.append(categoryToAdd)
                
                self.saveData()
                self.categoryTableView.reloadData()
            }
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
}

extension CategoryViewController : UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: categoryTableCellIdentifier, for: indexPath)
        
        let categoryItem = categoryArray[indexPath.row]
        cell.textLabel?.text = categoryItem.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print the category name that was tapped
        print("Category tapped is: \(String(describing: categoryArray[indexPath.row].name))")
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: Data Manipulation Methods
    
    //save and load data
    func loadData(){
        loadItemsFromCoreData()
    }
    
    func loadItemsFromCoreData(){
        if let categoryItemsResponse = fetchDataFromDbByRequest() {
            categoryArray = categoryItemsResponse
        }
    }
    
    func fetchDataFromDbByRequest(with request: NSFetchRequest<Category> = Category.fetchRequest()) -> [Category]? {
        do {
            let itemsResponse = try persistentContainerViewContext.fetch(request)
            return itemsResponse
        } catch {
            print("Error in fetchDataFromDbByRequest in decoding item array is \(error)")
        }
        
        return nil
    }
    
    func saveData(){
        saveItemsToCoreData()
    }
    
    func saveItemsToCoreData() {
        do {
            try persistentContainerViewContext.save()
        }
        catch{
            print("Error in saveItemsToCoreData in encoding item array is \(error)")
        }
        
        categoryTableView.reloadData()
    }
}
