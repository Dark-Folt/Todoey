//
//  ViewController.swift
//  Todoey
//
//  Created by Kamil Ben on 09/12/2018.
//  Copyright © 2018 Dark Folt. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard //Maintenant on peut utiliser userDefaults

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let item = Item()
        item.titile = "Find Mike"
        
        itemArray.append(item)

        
        let item1 = Item()
        item1.titile = "Manger mon gars"

        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
        
        
    }
    
    //MARK - TableView Datasource methodes
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.titile
        
        /*Ternary Operator ===>>
         
         valeur = condition ? valueIfTru : valueIfFalse
         */
        
        cell.accessoryType = item.done ? .checkmark : .none
//
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    
    //MARK - TableViewDelegate Methods
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true) // faire disparaitre la selection grise
    
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertTextField = UITextField()
        
        let alert = UIAlertController(title: "Ajouter un Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ajouter l'item", style: .default) { (action) in
            // Quand l'user click le ajouter button
            
            let newItem = Item()
            newItem.titile = alertTextField.text!
            
            self.itemArray.append(newItem)

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

