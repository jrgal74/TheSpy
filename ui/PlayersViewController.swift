//
//  PlayersViewController.swift
//  ui
//
//  Created by Muhammed Saad on 05/12/2023.
//

import UIKit

class PlayersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Data Source for player names
    var playerNames : [String] = []
    
    // UI Components
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    let addPlayerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Player", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(addPlayer), for: .touchUpInside)
        return button
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.green, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up UI components
        view.addSubview(tableView)
        view.addSubview(addPlayerButton)
        view.addSubview(startButton)
        
        // Set up layout constraints (adjust as needed)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addPlayerButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addPlayerButton.topAnchor, constant: -20),
            
            addPlayerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addPlayerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addPlayerButton.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -20),
            
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
        // Set the delegate and data source for the table view
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Button Actions
    
    @objc func addPlayer() {
        // Create a UIAlertController with a text field
        let alertController = UIAlertController(title: "Add Player", message: "Enter player's name", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Player Name"
        }
        
        // Add action to the UIAlertController
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            // Get the text entered by the user
            if let playerName = alertController.textFields?.first?.text, !playerName.isEmpty {
                // Check if the player name already exists in the list
                if !(self?.playerNames.contains(playerName) ?? false) {
                    // Append the player name to the playerNames array
                    self?.playerNames.append(playerName)
                    
                    // Reload the table view to reflect the updated player list
                    self?.tableView.reloadData()
                    
                    // Enable the start button if there are 3 or more players
                    self?.startButton.isEnabled = self?.playerNames.count ?? 0 >= 3
                } else {
                    // Display an error message (you can customize this part)
                    let errorAlert = UIAlertController(title: "Error", message: "Player name already exists", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    errorAlert.addAction(okAction)
                    self?.present(errorAlert, animated: true, completion: nil)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        // Present the UIAlertController
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func startGame() {
        guard playerNames.count >= 3 else {
            // Handle the case when there are not enough players
            return
        }
        
        // Create an array of items (customize as needed)
        let itemsArray = ["Key", "Book", "Phone", "Glasses", "Wallet", "Pen"]
        
        // Shuffle the player names to randomize their order
        let shuffledPlayerNames = playerNames.shuffled()
        
        // Select a random spy
        let spyIndex = Int(arc4random_uniform(UInt32(playerNames.count)))
        let spyName = shuffledPlayerNames[spyIndex]
        
        //        // Remove the spy from the player names array
        //        var playerNamesWithoutSpy = playerNames
        //        playerNamesWithoutSpy.removeAll { $0 == spyName }
        
        // Select a random item
        let selectedItemIndex = Int(arc4random_uniform(UInt32(itemsArray.count)))
        let selectedItem = itemsArray[selectedItemIndex]
        
        // Create a custom alert view controller
        let alertController = UIAlertController(title: "Pass the Phone", message: "Hand the phone to \(playerNames.first ?? "the next player").\nDo not look at the screen.", preferredStyle: .alert)
        
        // Add an action (OK) to proceed to GameDetailsViewController
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.presentGameDetails(playerNames: self?.playerNames ?? [], spyName: spyName, selectedItem: selectedItem)
        }))
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
    
    
    func presentGameDetails(playerNames: [String], spyName: String, selectedItem: String) {
        // Present the GameDetailsViewController
        let gameDetailsVC = storyboard?.instantiateViewController(withIdentifier: "GameDetailsVC") as! GameDetailsViewController
        gameDetailsVC.playerNames = playerNames
        gameDetailsVC.spyName = spyName
        gameDetailsVC.selectedItem = selectedItem
        
        // Present the GameDetailsViewController
        present(gameDetailsVC, animated: false, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = playerNames[indexPath.row]
        return cell
    }
}

