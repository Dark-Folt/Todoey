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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()

        
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
        saveItems() //Je l'appelle pour enregistrer le bool associé

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
            
            self.saveItems() //e l'appelle pour savegarder l'item et non pas le boolean assisié

            /*
             J'ai mis for key donc logement pour acceder dans cette base de donné je dois utiliser cette Key
             Pour cela on va aller dans le view deadload ensuite cibler nos éléments
             */
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Creer votre nouvel item"

            alertTextField = textField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK - Save Items
    
    private func saveItems() {
        /*Je vais enregister mon tableau*/
        let encoder = PropertyListEncoder()
        
        
        /*Maitenant je peux essayer d'encoder mes element*/
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    private func loadItems() {

        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
           
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error: \(error)")
            }
            
            
            
            /*J'ai encode mes éléments et maintenant je vais les décodé*/
        }
        
        
    }


}

