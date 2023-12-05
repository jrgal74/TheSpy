//
//  GameDetailsViewController.swift
//  ui
//
//  Created by Muhammed Saad on 05/12/2023.
//

import UIKit

class GameDetailsViewController: UIViewController {
    
    var detailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0 // Allow multiple lines for better readability
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    
    var selectedItem: String = ""
    var currentPlayerIndex = 0
    var playerNames: [String] = [] // Assuming you have an array of player names
    var spyName : String = ""
    var nextButton = UIButton(type: .system)
    var alertsDisplayed = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add detailsLabel as a subview
        view.addSubview(detailsLabel)
        
        // Set up layout constraints for detailsLabel (centered in the middle of the screen)
        NSLayoutConstraint.activate([
            detailsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        displayDetails()
        // Add Next button
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        // Add Next button to the view
        view.addSubview(nextButton)
        
        // Set up layout constraints for the Next button
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 20),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func displayDetails() {
        if currentPlayerIndex < playerNames.count {
            let currentName = playerNames[currentPlayerIndex]
            
            if currentName == spyName {
                detailsLabel.text = "\(currentName), you are the Spy! Try to guess the item."
            } else {
                detailsLabel.text = "\(currentName), you are not the Spy. The selected item is \(selectedItem)."
            }
        }
    }
    
    @objc func nextButtonTapped() {
        alertsDisplayed += 1
        currentPlayerIndex += 1
        if alertsDisplayed < playerNames.count {
        let alert = UIAlertController(title: "pass the phone", message: "Hand the phone to \(playerNames[currentPlayerIndex % playerNames.count]).\nDo not look at the screen.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.modalPresentationStyle = .overFullScreen
            present(alert, animated: false, completion: nil)
            displayDetails()
        }
        else {
            showStartButton()
        }
    }
    
    func showStartButton() {
        detailsLabel.text = "Start Game"
        nextButton.setTitle("Start Game", for: .normal)
        nextButton.removeTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc func startButtonTapped() {
        presentGameQuestions(playerNames: playerNames)
    }
    
    func presentGameQuestions(playerNames: [String]) {
        // Present the GameDetailsViewController
        let gameQuestionsVC = storyboard?.instantiateViewController(withIdentifier: "gameQuestionsVC") as! QuestionsViewController
        gameQuestionsVC.playerNames = playerNames
        gameQuestionsVC.spyName = spyName
        gameQuestionsVC.selectedItem = selectedItem
        
        // Present the GameDetailsViewController
        present(gameQuestionsVC, animated: true, completion: nil)
    }

}

