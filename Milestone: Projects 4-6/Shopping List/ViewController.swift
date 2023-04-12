//
//  ViewController.swift
//  Shopping List
//
//  Created by Kadirhan Keles on 12.04.2023.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        title = "Shopping List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButton))
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
        view = tableView
        let tableView = self.tableView
        
        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    @objc func addItem(){
        let ac = UIAlertController(title: "Enter Product", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let product = ac?.textFields?[0].text else { return }
            self?.shoppingList.insert(product, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func shareButton(){
        let list = shoppingList.joined(separator: "\n")
        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(vc, animated: true)
    }
    
    

}

extension ViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingList.remove(at: indexPath.row) // Diziden seçilen hücreyi sil
            tableView.deleteRows(at: [indexPath], with: .fade) // TableView'dan seçilen hücreyi sil
        }
    }

}

