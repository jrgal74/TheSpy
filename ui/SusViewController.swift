import UIKit

class SusViewController: UIViewController {
    
    var playerNames: [String] = []  // Assuming you passed the playerNames from the previous view controller
    var currentQuestionIndex = 0
    var currentQuestioner: String = ""
    var lastAskedPlayer: String = ""
    var spyName : String = ""
    var questionLabel: UILabel!
    var playerButtons: [UIButton] = []
    var selectedItem: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial setup
        setupUI()
        displayNextQuestion()
    }
    
    func setupUI() {
        // Create and configure the question label
        questionLabel = UILabel()
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 0  // Allow multiple lines if needed
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(questionLabel)
        
        // Add constraints for the question label
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        // Create and configure the "Submit" button
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.blue, for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submitButton)
        
        // Add constraints for the "Submit" button
        NSLayoutConstraint.activate([
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func submitButtonTapped() {
        // Handle "Submit" button action
        // You can implement the logic to submit the answers or transition to another view controller
        let resultViewController = ResultViewController()
        // Pass the player names to the ResultViewController
        resultViewController.playerNames = playerNames
        resultViewController.spyName = spyName
        resultViewController.selectedItem = selectedItem
        // Perform the segue to ResultViewController with an identifier
        performSegue(withIdentifier: "resultVC", sender: self)
    }
    
    // Override prepare(for:sender:) to pass data to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultVC" {
            if let resultViewController = segue.destination as? ResultViewController {
                // Pass the player names to ResultViewController
                resultViewController.playerNames = playerNames
                resultViewController.spyName = spyName
                resultViewController.selectedItem = selectedItem
            }
        }
    }
    
    func updatePlayerButtons(choices: [String]) {
        // Remove existing buttons from the view
        playerButtons.forEach { $0.removeFromSuperview() }
        playerButtons.removeAll()
        
        // Create and configure the player buttons
        for (index, playerName) in choices.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(playerName, for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.addTarget(self, action: #selector(playerButtonTapped(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            playerButtons.append(button)
            view.addSubview(button)
            
            // Add constraints for the player buttons
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: CGFloat(index * 40 + 20)),
                button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            ])
        }
    }
    
    
    func displayNextQuestion() {
        if currentQuestionIndex < playerNames.count {
            currentQuestioner = playerNames[currentQuestionIndex]
            questionLabel.text = "\(currentQuestioner) asks:"
            
            // Update the player buttons with choices excluding the last asked player and current questioner
            let choices = playerNames.filter { $0 != lastAskedPlayer && $0 != currentQuestioner }
            updatePlayerButtons(choices: choices)
            
            // Increment the question index for the next question
            currentQuestionIndex += 1
        } else {
            // Handle the end of questions, if needed
            // Update the text in the view with a custom message
            questionLabel.text = "All questions have been answered."
            
            // Remove existing buttons from the view
            playerButtons.forEach { $0.removeFromSuperview() }
            playerButtons.removeAll()
            
            print("End of questions")
        }
    }
    
    @objc func playerButtonTapped(_ sender: UIButton) {
        guard let selectedPlayer = sender.currentTitle else {
            return
        }
        
        // Handle the selected player as needed
        print("Selected player: \(selectedPlayer)")
        
        // Update last asked player
        lastAskedPlayer = currentQuestioner
        
        // Display the next question
        displayNextQuestion()
    }
}
