import UIKit

class ResultViewController: UIViewController {
    
    var playerNames: [String] = []
    var spyName: String = ""
    var answers: [String: String] = [:]
    var scores: [String: Int] = [:]
    var selectedItem: String = ""
    
    // Index to keep track of the current voter
    var currentVoterIndex: Int = 0
    
    // UI Elements
    let voteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Declare the submit button as a class variable
    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    // Array to keep references to player buttons
    var playerButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up UI
        setupUI()
        
        // Start the voting process
        startVoting()
    }
    
    func setupUI() {
        // Configure the vote label
        view.addSubview(voteLabel)
        
        // Create and configure the submit button
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        view.addSubview(submitButton)
        
        // Set constraints for the vote label
        NSLayoutConstraint.activate([
            voteLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            voteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Set constraints for the submit button (bottom of the screen)
        NSLayoutConstraint.activate([
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func startVoting() {
        // Start the voting process by asking the first player to vote
        chooseNextVoter()
    }
    
    func chooseNextVoter() {
        // Clear previous UI
        clearPreviousUI()
        
        // Choose the next voter who hasn't voted yet
        let currentVoter = playerNames[currentVoterIndex]
        
        // Set the vote label text with the current voter's name
        voteLabel.text = "\(currentVoter), vote for who you think is the spy:"
        
        // Create and configure player buttons for voting
        var lastButton: UIButton?
        for playerName in playerNames {
            // Exclude the current voter's name
            guard playerName != currentVoter else {
                continue
            }
            
            let button = UIButton(type: .system)
            button.setTitle(playerName, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(playerButtonTapped(_:)), for: .touchUpInside)
            view.addSubview(button)
            playerButtons.append(button)
            
            // Set constraints for player buttons
            NSLayoutConstraint.activate([
                button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                button.widthAnchor.constraint(equalToConstant: 200),
                button.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            if let lastButton = lastButton {
                // Set the top anchor of the current button to the bottom anchor of the last button
                button.topAnchor.constraint(equalTo: lastButton.bottomAnchor, constant: 20).isActive = true
            } else {
                // Set the top anchor of the first button to the bottom of the vote label
                button.topAnchor.constraint(equalTo: voteLabel.bottomAnchor, constant: 20).isActive = true
            }
            
            lastButton = button
        }
    }
    
    
    func clearPreviousUI() {
        // Clear previous player buttons
        for button in playerButtons {
            button.removeFromSuperview()
        }
        playerButtons.removeAll()
        
        // Hide the submit button
        submitButton.isHidden = true
    }
    
    @objc func playerButtonTapped(_ sender: UIButton) {
        guard let votedPlayer = sender.currentTitle else {
            return
        }
        
        // Save the vote for the current voter
        let currentVoter = playerNames[currentVoterIndex]
        answers[currentVoter] = votedPlayer
        
        // Check if all players have voted
        if currentVoterIndex == playerNames.count - 1 {
            // All players have voted, show the submit button
            submitButton.isHidden = false
            // Hide the vote label and buttons
            voteLabel.isHidden = true
            for button in playerButtons {
                button.isHidden = true
            }
        } else {
            // Continue the voting process
            currentVoterIndex += 1
            chooseNextVoter()
        }
    }
    
    @objc func submitButtonTapped() {
        // Handle the submit button action if needed
        print("Submit button tapped!")
        // Calculate scores
        calculateScores()
        print(scores)
        presentSpyView(playerNames: playerNames)
    }
    
    func calculateScores() {
        for (voter, votedPlayer) in answers {
            // Exclude the spy from scoring
//            guard voter != spyName else {
//                continue
//            }
            if (votedPlayer == spyName && voter != spyName) {
                // Voter chose the spy correctly
                scores[voter] = (scores[voter] ?? 0) + 100
            } else if (votedPlayer != spyName && voter != spyName) {
                // Voter chose incorrectly
                scores[voter] = (scores[voter] ?? 0) - 25
            } else {
                scores[voter] = (scores[voter] ?? 0)
            }
        }
    }
    
    func presentSpyView(playerNames: [String]) {
        // Present the GameDetailsViewController
        let spyVC = SpyViewController()
        spyVC.playerNames = playerNames
        spyVC.spyName = spyName
        spyVC.selectedItem = selectedItem
        spyVC.scores = scores
        performSegue(withIdentifier: "spyVC", sender: self)
    }
    
    // Override prepare(for:sender:) to pass data to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "spyVC" {
            if let spyViewController = segue.destination as? SpyViewController {
                // Pass the player names to ResultViewController
                spyViewController.playerNames = playerNames
                spyViewController.spyName = spyName
                spyViewController.selectedItem = selectedItem
                spyViewController.scores = scores
            }
        }
    }
}

