//
//  ViewController.swift
//  Project-05
//
//  Created by Kadirhan Keles on 8.04.2023.
//

import UIKit

class ViewController: UITableViewController {

    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Dosya yolu oluşturma adı start, uzantısı txt olanı bul.
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty{
            allWords = ["silkworm"]
        }
        
        setupUI()
        startGame()
    }
    
    func setupUI(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))

        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
        view = tableView
        let tableView = self.tableView
        view.backgroundColor = .white
        tableView?.delegate = self
        tableView?.dataSource = self
           
       }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(lowerAnswer, at: 0)
                    // tableview.reloaddata bir değişiklik için çok fazla ekstra iş anlamına gelir
                    //indexPath, TableView'da belirli bir hücreyi (satır ve sütun) belirtir. Burada, kelimenin eklenmesi gereken ilk satırın sıfırıncı indeksi olduğu ve TableView'in sıfırıncı bölümünde olduğu belirtilmiştir. insertRows(at:with:) metodunun "with" parametresi, yeni satırın nasıl ekleneceğini belirler ve burada .automatic değeri, TableView'in otomatik olarak bir animasyonla yeni satırı eklemesini sağlar.
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                }
            }
        }
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        if word != tempWord {
            for letter in word {
                if let position = tempWord.firstIndex(of: letter) {
                    tempWord.remove(at: position)
                        } else {
                            showErrorMessage(errorTitle:  "Word not possible", errorMessage: "You can't spell that word from \(title!)")
                            return false
                            }
                        }

            return true
        }
        showErrorMessage(errorTitle:  "Word not possible", errorMessage: "You can't spell that word from \(self.title!)")
        return false
            
    }

    func isOriginal(word: String) -> Bool {
        if !usedWords.contains(word) == false {
            showErrorMessage(errorTitle:  "Word already used", errorMessage: "Be more original!")
        }
            return !usedWords.contains(word)
            
       
    }

    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        if range.length >= 3 {
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            if misspelledRange.location != NSNotFound {
                showErrorMessage(errorTitle: "Word not recognised", errorMessage: "You can't just make them up, you know!")
            }
            return misspelledRange.location == NSNotFound ? true : false
        } else {
            showErrorMessage(errorTitle: "Word not recognised", errorMessage: """
                        Rules are: word must exist, \
                        must be 3 letters at least, \
                        must be different than original word
                        """)
            return false
        }
        
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
}

extension ViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
}
    
