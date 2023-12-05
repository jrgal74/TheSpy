//
//  ScoreViewController.swift
//  ui
//
//  Created by Muhammed Saad on 17/01/2024.
//

import UIKit

class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Your existing code
    var playerNames: [String] = []
    var scores: [String: Int] = [:]
    
    // Your existing code
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure your UITableView
        setupTableView()
        
        // Add "Play Again" button
        let playAgainButton = UIButton(type: .system)
        playAgainButton.setTitle("Play Again", for: .normal)
        playAgainButton.translatesAutoresizingMaskIntoConstraints = false
        playAgainButton.addTarget(self, action: #selector(playAgainButtonTapped), for: .touchUpInside)
        view.addSubview(playAgainButton)
        
        // Set constraints for the "Play Again" button
        NSLayoutConstraint.activate([
            playAgainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playAgainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // Function to set up the UITableView
    func setupTableView() {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        // Set constraints for the UITableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Register the cell for the UITableView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ScoreCell")
    }
    
    // UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
        
        // Extract player name and score for the current row
        let playerName = Array(scores.keys)[indexPath.row]
        let score = scores[playerName] ?? 0
        
        // Customize the cell's appearance (e.g., player name on the left, score on the right)
        cell.textLabel?.text = "\(playerName): \(score) points"
        
        return cell
    }
    
    
    @objc func playAgainButtonTapped() {
            // Perform the segue back to the initial view controller
            performSegue(withIdentifier: "playAgainSegue", sender: nil)
        }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Pass the player names to the initial view controller during the segue
            if segue.identifier == "playAgainSegue" {
                if let playerViewController = segue.destination as? PlayersViewController {
                    playerViewController.playerNames = playerNames
                }
            }
        }
    
    // UITableViewDelegate methods (if needed)
}

