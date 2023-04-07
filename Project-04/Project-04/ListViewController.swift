//
//  ListViewController.swift
//  Project-04
//
//  Created by Kadirhan Keles on 7.04.2023.
//

import UIKit

class ListViewController: UIViewController {
    
    var websites = ["apple.com", "hackingwithswift.com","instagram.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()

   

}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = websites[indexPath.row]
        cell.contentConfiguration = content
                
        let disclosureIndicator = UITableViewCell.AccessoryType.disclosureIndicator
        cell.accessoryType = disclosureIndicator
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let websiteVC = ViewController()
        websiteVC.websites = websites
        websiteVC.selectedIndex = indexPath.row
        navigationController?.pushViewController(websiteVC, animated: true)
        
    }
    
    
}
