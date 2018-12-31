//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Kamil Ben on 31/12/2018.
//  Copyright © 2018 Dark Folt. All rights reserved.
//

import UIKit
import CoreData



class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //Ajout des category
        
        var alertTextField = UITextField()
        
        let alert = UIAlertController(title: "Category", message: "Ajouter une category pour la representation de votre liste", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ajouter", style: .default) { (UIAlertAction) in
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = alertTextField.text!
            
            //J'ajoute mes élément dans mon tableau de category
            self.categoryArray.append(newCategory)
            
            //Une fois que j'ai fais tout ça et bah je vais le sauvegarder
            self.saveCategory()
            
            
            
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Entrer le titre de votre categorie"
            
            alertTextField = textField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]

        cell.textLabel?.text = category.name == "" ? "Nouvelle categorie" : category.name
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destionVC = segue.destination as! TodoListViewController
        
        //Je vais essayer d'acceder à la current Items quand j'appuie sur une categorie
        
        if let categoryIndexPath = tableView.indexPathForSelectedRow {
            destionVC.selectedCategory = categoryArray[categoryIndexPath.row]
            
            //selectedCategory sera dns la VC de destination
        }
        
    }
    
    
    //MARK - Data Manipulations
    
    private func saveCategory(){
        
        do {
            try context.save()
            print("Save")
        } catch  {
            print("Error when we try to trieve data.")
        }
        
        self.tableView.reloadData()
    }
    
    private func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do {
           categoryArray  = try context.fetch(request)
        } catch  {
            print("Error when feteching Data")
        }
        
        tableView.reloadData()
        
    }
    

}
