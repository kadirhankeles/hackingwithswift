//
//  ViewController.swift
//  Flag Show
//
//  Created by Kadirhan Keles on 4.04.2023.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    
    override func loadView() {
        tableView = UITableView(frame: .zero, style: .plain)
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
        setupUI()
    }
    
    func fetchImage(){
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items{
            if item.hasSuffix(".png"){
                pictures.append((item as NSString).deletingPathExtension)
            }
        }
        pictures.sort()
    }
    
    func setupUI(){
        title = "Country Flags"
        navigationController?.navigationBar.prefersLargeTitles = true
        let tableView = self.tableView
        view.backgroundColor = .white
        tableView?.delegate = self
        tableView?.dataSource = self
        
    }
    
    
    
}

extension ViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = pictures[indexPath.row]
        cell.contentConfiguration = content
        
        let disclosureIndicator = UITableViewCell.AccessoryType.disclosureIndicator
        cell.accessoryType = disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.flagName = pictures[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

