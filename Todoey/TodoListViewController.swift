//
//  ViewController.swift
//  Todoey
//
//  Created by Kamil Ben on 09/12/2018.
//  Copyright © 2018 Dark Folt. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [String]()
    
    let defaults = UserDefaults.standard //Maintenant on peut utiliser userDefaults

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
        
        
    }
    
    //MARK - TableView Datasource methodes
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    
    //MARK - TableViewDelegate Methods
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

   if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
   }else{
    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertTextField = UITextField()
        
        let alert = UIAlertController(title: "Ajouter un Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ajouter l'item", style: .default) { (action) in
            // Quand l'user click le ajouter button
            
            self.itemArray.append(alertTextField.text!)

            /*Je vais enregister mon tableau*/
            self.defaults.set(self.itemArray, forKey: "TodoListArray")

            /*
             J'ai mis for key donc logement pour acceder dans cette base de donné je dois utiliser cette Key
             
             Pour cela on va aller dans le view deadload ensuite cibler nos éléments
             */
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Creer votre nouvel item"

            alertTextField = textField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }


}

