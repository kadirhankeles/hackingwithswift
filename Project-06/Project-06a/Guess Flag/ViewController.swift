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
        
        NSLayoutConstraint.activate([
                    // Button 1
                    button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    button.widthAnchor.constraint(equalToConstant: 200),
                    button.heightAnchor.constraint(equalToConstant: 100),
                    button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                    
                    // Button 2
                    button2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    button2.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
                    button2.widthAnchor.constraint(equalTo: button.widthAnchor),
                    button2.heightAnchor.constraint(equalTo: button.heightAnchor),
                    
                    // Button 3
                    button3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    button3.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 20),
                    button3.widthAnchor.constraint(equalTo: button.widthAnchor),
                    button3.heightAnchor.constraint(equalTo: button.heightAnchor),
                    button3.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
                ])
        
        
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

