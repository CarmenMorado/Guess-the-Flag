//
//  ViewController.swift
//  Project2
//
//  Created by Carmen Morado on 10/11/20.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionNumber = 0
    var highScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion(action: nil)
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        let defaults = UserDefaults.standard
        
        if let savedScore = defaults.object(forKey: "highScore") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                highScore = try jsonDecoder.decode(Int.self, from: savedScore)
            }
            
            catch {
                print("Failed to save the data.")
            }
        }
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
            
        correctAnswer = Int.random(in: 0...2)
            
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
            
        title = countries[correctAnswer].uppercased() + "  Score: \(score)"
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        questionNumber += 1

        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        
        if  questionNumber == 10 {
            title = "Done!"
            navigationItem.title = countries[correctAnswer].uppercased() + "  Score: \(score)"
            
            if score > highScore {
                highScore = score
                saveHighScore()
                let ac = UIAlertController(title: title, message: "Your new high score and final score is \(highScore)!", preferredStyle: .alert)
                present(ac, animated: true)
            }
            
            let ac = UIAlertController(title: title, message: "Your final score is \(score).", preferredStyle: .alert)
            present(ac, animated: true)
        }
        
        if title == "Wrong" {
            let ac = UIAlertController(title: title, message: "That's the flag of \(countries[sender.tag].uppercased())! Your score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        }
        
        if highScore == 0 {
            highScore = score
            saveHighScore()
        }
        
        else {
            if score > highScore && score > 0 {
                highScore = score
                saveHighScore()
                let ac = UIAlertController(title: title, message: "Your new high score is \(highScore)!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
                present(ac, animated: true)
            }
        }
        
        let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
    
    func saveHighScore() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(highScore) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "highScore")
        } else {
            print("Failed to save the high score.")
        }
    }
    
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: ["Score: \(score)"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    

}

