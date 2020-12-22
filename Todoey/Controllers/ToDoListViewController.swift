//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    //create a file path to the document directory as a variable for the class
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print(dataFilePath)
        
        loadItems()
        
       
    }

    
    
    //MARK: - TableView Datasource Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
        
    }
    
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //toogle the property var "done"
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        //force the table view to recall its data source methods again
     
        
        //let the clicked cell only flash rather than marked as grey
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
         
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //create a local variable for the scope of the addButtonPressed (in order to use the variable within this scope)
        var textField = UITextField()
        
        //create an UIAlertViewController
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        //
        let action = UIAlertAction(title: "Add new ToDoey", style: .default) { (schulz) in
            //what will happen once the user clicks the the Add Item button on our UIAlert
            let newItem = Item()
            newItem.title = textField.text ?? "New Item"
            self.itemArray.append(newItem)
            
            //save the new Item in the array
            self.saveItems()
            
        }
        
        //add a text field to the UIAlertViewController
        //all the following code is executed when the text field is added to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        //this is a function call with a closure as argument
        alert.addAction(action)
        
        //present our UIAlertController
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        //save the itemArray with the new element
        //1. create an instance of an encoder
        let encoder = PropertyListEncoder()
        //2. encode the data and 3. write them to the disk
        do {
            let data = try? encoder.encode(itemArray)
            try data!.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error )")
        }
        
        tableView.reloadData()
    }
    
    
    func loadItems() {
        if let data =  try? Data(contentsOf: dataFilePath!) {
             let decoder = PropertyListDecoder()
             do {
             itemArray = try decoder.decode([Item].self, from: data)
             } catch {
                 print("Error decoding item array, \(error)")
             }
         }
        
    }
}

