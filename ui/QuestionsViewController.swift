import UIKit

class QuestionsViewController: UIViewController {
    
    var playerNames: [String] = []  // Assuming you pass the playerNames from the previous view controller
    var currentIndex = 0  // To keep track of the current question index
    var questionPairs: [(String, String)] = []
    var remainingResponders: Set<String> = []
    var containerView: UIView!
    var spyName : String = ""
    var selectedItem: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Your setup code
        questionPairs = createQuestionPairs()
        
        // Create a container view to center the questions label
        containerView = UIView()
        containerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)  // Set the background color as needed
        containerView.layer.cornerRadius = 10  // Add corner radius for a rounded appearance
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // Add Auto Layout constraints to center the containerView within the safe area
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),  // Adjust multiplier as needed
            containerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)  // Adjust multiplier as needed
        ])
        
        // Iterate through pairs and display questions
        let questionLabel = UILabel()
        questionLabel.numberOfLines = 0  // Allow multiple lines if needed
        questionLabel.textAlignment = .center
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(questionLabel)
        
        // Add constraints for the questionLabel inside the containerView
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
        
        // Display the first question
        displayQuestion(questionLabel, questionPairs[currentIndex])
        
        // Create a "Next" button
        let nextButton = UIButton(type: .system)
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nextButton)
        
        // Add constraints for the "Next" button
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            nextButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
    
    func displayQuestion(_ label: UILabel, _ pair: (String, String)) {
        label.text = "\(pair.0) asks: What do you think about \(pair.1)'s answer?"
    }
    
    @objc func nextButtonTapped() {
        currentIndex += 1
        // Check if there are more questions
        if currentIndex < questionPairs.count  {
            let questionLabel = containerView.subviews.compactMap { $0 as? UILabel }.first
            displayQuestion(questionLabel!, questionPairs[currentIndex])
        } else {
            presentSusQuestions(playerNames: playerNames)
        }
        
    }
    
    func presentSusQuestions(playerNames: [String]) {
        // Present the GameDetailsViewController
        let susVC = storyboard?.instantiateViewController(withIdentifier: "susVC") as! SusViewController
        susVC.playerNames = playerNames
        susVC.spyName = spyName
        susVC.selectedItem = selectedItem
        
        // Present the GameDetailsViewController
        present(susVC, animated: true, completion: nil)
    }
    
    
    func createQuestionPairs() -> [(String, String)] {
        let shuffledPlayers = playerNames.shuffled()
        var questionPairs: [(String, String)] = []
        
        for questioner in shuffledPlayers {
            let filteredResponders = shuffledPlayers.filter { $0 != questioner && !remainingResponders.contains($0) }
            // Ensure each questioner asks exactly one question with a random and non-repeating responder
            guard let responder = filteredResponders.randomElement() else {
                break  // No more available responders
            }
            // Ensure each questioner asks exactly one question with a random and non-repeating responder
            
            questionPairs.append((questioner, responder))
            remainingResponders.insert(responder)
            
        }
        return questionPairs
    }
}
