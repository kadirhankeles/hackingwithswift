//
//  ViewController.swift
//  Guess Flag
//
//  Created by Kadirhan Keles on 28.03.2023.
//

import UIKit

class ViewController: UIViewController {
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionNumber = 0
    
    lazy var button = CustomButton(imageName: "us",tag: 0)
    lazy var button2 = CustomButton(imageName: "us",tag: 1)
    lazy var button3 = CustomButton(imageName: "us",tag: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        askQuestion(action: nil)
        setupUI()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        questionNumber += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button.setImage(UIImage(named:  countries[0]), for: .normal)
        button2.setImage(UIImage(named:  countries[1]), for: .normal)
        button3.setImage(UIImage(named:  countries[2]), for: .normal)
        
        title = "\(countries[correctAnswer].uppercased()) - \(score) "
    }
    
    func setupUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(button)
        view.addSubview(button2)
        view.addSubview(button3)
        
        button.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        button.anchor(width: 200, height: 100)
        
        button2.centerX(inView: view, topAnchor: button.bottomAnchor, paddingTop: 40)
        button2.anchor(width: 200, height: 100)
        
        button3.centerX(inView: view, topAnchor: button2.bottomAnchor, paddingTop: 40)
        button3.anchor(width: 200, height: 100)
        
        
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        button2.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        button3.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        
    }
    
    @objc func buttonClicked(_ sender: UIButton){
        var title: String
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong, that's the flag of \(countries[sender.tag].uppercased())"
            score -= 1
        }
        
        if questionNumber == 10 {
            let ac = UIAlertController(title: "Congratulations", message: "Your score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play again", style: .default, handler: askQuestion))
            present(ac, animated: true)
            questionNumber = 0
            correctAnswer = 0
            score = 0
        } else {
            let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        }
        
    }

    
}

