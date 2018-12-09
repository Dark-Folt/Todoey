//
//  ViewController.swift
//  Todoey
//
//  Created by Kamil Ben on 09/12/2018.
//  Copyright © 2018 Dark Folt. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let itemArrat = ["Find Mike","Buy Eggos","Destrpy Demogorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    //MARK - TableView Datasource methodes
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArrat.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        cell.textLabel?.text = itemArrat[indexPath.row]
        
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


}

