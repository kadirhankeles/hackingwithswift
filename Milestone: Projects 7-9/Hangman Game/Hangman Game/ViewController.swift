
import UIKit

class ViewController: UIViewController {
    var letterButtons = [UIButton]()
    var WordList = [String]()
    var guessLabel = UILabel()
    var scoreLabel = UILabel()
    var score = 0
    var questionNumber = 0
    var health = 6
    var imageNumber = 1
    let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    var questionMarks: String?
    let imageView = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width / 2 - 120, y: 100, width: 250, height: 250))
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel()
        
    }
    
    func loadLevel() {
        DispatchQueue.global(qos: .userInitiated).async {
            if let levelFileURL = Bundle.main.url(forResource: "Words", withExtension: "txt") {
                if let levelContents = try? String(contentsOf: levelFileURL) {
                    self.WordList = levelContents.components(separatedBy: "\n")
                    DispatchQueue.main.async {
                        self.setupUI()
                    }
                }
            }
        }
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(red: 0.26, green: 0.11, blue: 0.61, alpha: 1.00)
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.textColor = .white
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        guessLabel.translatesAutoresizingMaskIntoConstraints = false
        guessLabel.textAlignment = .center
        guessLabel.textColor = .white
        guessLabel.font = UIFont.systemFont(ofSize: 32)
        view.addSubview(guessLabel)
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "0")
        view.addSubview(imageView)
        
        questionMarks = String(repeating: "?", count: WordList[questionNumber].count)
        guessLabel.text = questionMarks
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            guessLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 80),
            guessLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            guessLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 350),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: guessLabel.bottomAnchor, constant: 80),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        let width = 35
        let height = 35
        let spacing = 10
        
        
        for row in 0..<4 {
            for column in 0..<8 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
                let index = row * 8 + column
                if index < alphabet.count {
                    let letter = alphabet[alphabet.index(alphabet.startIndex, offsetBy: index)]
                    letterButton.setTitle(String(letter), for: .normal)
                } else {
                    letterButton.isHidden = true // buton tamamen görünmez yapılıyor
                }
                let x = column * (width + spacing)
                let y = row * (height + spacing)
                let frame = CGRect(x: x, y: y, width: width, height: height)
                letterButton.frame = frame
                letterButton.tintColor = .white
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.black.cgColor
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }
        
        
        
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else {return}
        
        sender.isHidden = true
        
        var index = 0
        for char in WordList[questionNumber]{
            if char.uppercased() == buttonTitle {
                let wordindex = questionMarks!.index(questionMarks!.startIndex, offsetBy: index)
                questionMarks!.replaceSubrange(wordindex...wordindex, with: buttonTitle)
            }
            index += 1
        }
        
        if !WordList[questionNumber].contains(buttonTitle.lowercased()) {
            health -= 1
            imageView.image = UIImage(named: "\(imageNumber)")
            imageNumber += 1
            if health == 0 {
                showError(title: "You lost", message: "you failed the hanging game.", buttonTitle: "Play Again")
                questionNumber = 0
                health = 6
                imageNumber = 1
                score = 0
                scoreLabel.text = "Score: \(score)"
                for button in letterButtons {
                    button.removeFromSuperview()
                }
                letterButtons.removeAll()
                setupUI()
            }
        }
        
        if questionMarks?.contains("?") == false {
            showError(title: "Congratulations", message: "Level \(questionNumber+1) finished.", buttonTitle: "Next Level")
            levelUp()
        }
        
        guessLabel.text = questionMarks
    }

    
    func levelUp () {
        questionNumber += 1
        health = 6
        imageNumber = 1
        DispatchQueue.main.async {
            self.score += 1
            self.scoreLabel.text = "Score: \(self.score)"
            
        }
        for button in letterButtons {
            button.removeFromSuperview()
        }
        letterButtons.removeAll()
        setupUI()
        
      
    }
    
    func showError(title: String, message: String, buttonTitle: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: buttonTitle, style: .cancel)
        ac.addAction(ok)
        present(ac, animated: true)
    }
    
    
}


