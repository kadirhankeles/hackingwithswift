//
//  ViewController.swift
//  Project-07
//
//  Created by Kadirhan Keles on 13.04.2023.
//

import UIKit

class ViewController: UITabBarController {

    public var searchWord = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showNotice))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(search))
        
        let vc1 = TableViewController()
        let vc2 = SecondViewController()
        vc1.title = "Most Recent"
        vc2.title = "Favorite"
        self.setViewControllers([vc1,vc2], animated: false)
        guard let items = self.tabBar.items else {return}
        let images = ["alarm.fill","star.fill"]
        self.tabBar.tintColor = .black
        self.tabBar.backgroundColor = .white.withAlphaComponent(0.7)
        for i in 0...1 {
            items[i].image = UIImage(systemName: images[i])
        }
    }
    
    @objc func showNotice() {
        let ac = UIAlertController(title: nil, message: "The data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func search() {
        let ac = UIAlertController(title: "Search", message: "Enter the word you want to find", preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let word = ac?.textFields?[0].text else { return }
            self?.filterPetitions(word)
            }
        ac.addAction(submitAction)
        present(ac, animated: true)
        }
    
    func filterPetitions(_ searchText: String) {
        if searchText.isEmpty {
            guard let tableVC = self.viewControllers?.first as? TableViewController else { return }
            tableVC.fakePetitions = tableVC.petitions
            tableVC.tableView.reloadData()
            return
        } else {
            guard let tableVC = self.viewControllers?.first as? TableViewController else { return }
            tableVC.fakePetitions = tableVC.petitions.filter { petition in
                return petition.title.localizedCaseInsensitiveContains(searchText) || petition.body.localizedCaseInsensitiveContains(searchText)
            }
            tableVC.tableView.reloadData()
        }
    }

}



class TableViewController: UITableViewController {
    var fakePetitions = [PetitionModel]()
    var petitions = [PetitionModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
      
        performSelector(inBackground: #selector(fetchData), with: nil)
        setupUI()
    }
    
    @objc func fetchData(){
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    parse(json: data)
                    return
                }
            }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
           
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            fakePetitions = petitions
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func setupUI(){
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
        view = tableView
        
    }
    
  
}

class SecondViewController: UITableViewController {

    var petitions = [PetitionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupUI()
    }
    
    func fetchData(){
        let urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self.parse(json: data)
                    return
                }
            }
            self.showError(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.")
        }
           
       
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func setupUI(){
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
        view = tableView
    }
}


extension TableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakePetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = fakePetitions[indexPath.row].title
        cell.accessoryType = .disclosureIndicator // add disclosure indicator
        cell.textLabel?.numberOfLines = 1 // allow multiple lines for title
        cell.textLabel?.lineBreakMode = .byTruncatingTail // allow line break at word boundaries for title
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16) // set bold font for title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SecondViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = petitions[indexPath.row].title
        cell.accessoryType = .disclosureIndicator // add disclosure indicator
        cell.textLabel?.numberOfLines = 1 // allow multiple lines for title
        cell.textLabel?.lineBreakMode = .byTruncatingTail // allow line break at word boundaries for title
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16) // set bold font for title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension UIViewController {
   @objc func showError(title: String?, message: String) {
        
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        
    }
}

/*
 internetten veri indirmek için Data'nın contentsOf özelliğini kullandık, bu da engelleme çağrısı olarak bilinir. Yani, sunucuya bağlanana ve tüm verileri tamamen indirene kadar yöntemdeki diğer kodların yürütülmesini engeller.
 
 
 */
