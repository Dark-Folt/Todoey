//
//  ViewController.swift
//  Todoey
//
//  Created by Kamil Ben on 09/12/2018.
//  Copyright © 2018 Dark Folt. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController{
    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK - TableView Datasource methodes
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        /*Ternary Operator ===>>
         
         valeur = condition ? valueIfTru : valueIfFalse
        
         */
        
        cell.textLabel?.text = item.title == "" ? "Noveau Item" : item.title
        
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
    
    //MARK - TableViewDelegate Methods
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    

    //      itemArray[indexPath.row].done = !itemArray[indexPath.row].done

    //MARK- Supression des deonnées
//        context.delete(itemArray[indexPath.row]) //Sa d'abord le premier
//        itemArray.remove(at: indexPath.row)
    
    
        saveItems() //Je l'appelle pour enregistrer le bool associé

        tableView.deselectRow(at: indexPath, animated: true) // faire disparaitre la selection grise
    
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var alertTextField = UITextField()
        
        let alert = UIAlertController(title: "Ajouter un Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ajouter l'item", style: .default) { (action) in
            // Quand l'user click le ajouter button
            
            let newItem = Item(context: self.context)
            newItem.title = alertTextField.text ?? "Nouveau Item"
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems() //e l'appelle pour savegarder l'item et non pas le boolean assosié

            /*
             J'ai mis for key donc logiqueement pour acceder dans cette base de donné je dois utiliser cette Key
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
    
    
    //MARK - Save and load Items
    
    private func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving Context: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    private func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        //Afficher les bon items
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionnalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionnalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        }catch{
            print("Error: Fetching Data : \(error)")
        }
        
        tableView.reloadData() //Pour encore afficher seules les mots contenant le mot clés
        
    }

}



extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        /*Je regarde s'il ya des caractères dans notre bar de recherche et sinon on revient dans la list original*/
        if searchBar.text?.count == 0 {
            loadItems() //On appelle load item pour faire la requete de nos items s'il y'en a
            
            //Hitoir de main thread et de background thread
            /*On ramene notre TV dans son état itial une fois qu'on a annulé la recherche*/
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
