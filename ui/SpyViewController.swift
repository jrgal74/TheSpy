import UIKit

class SpyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var items: [String] = ["Dog", "Cat", "Rabbit", "Pencil", "Telephone", "Table", "Bed"]
    var playerNames : [String] = []
    var scores: [String: Int] = [:]
    var spyName: String = ""
    var selectedItem: String = ""
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ChoiceCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items.append(selectedItem)
        items.shuffle()
        generateQuestion()
        setupUI()
    }
    func generateQuestion() {
        questionLabel.text = "\(spyName), what was your friends talking about?"
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(questionLabel)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChoiceCell", for: indexPath)
        cell.backgroundColor = UIColor.blue
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = items[indexPath.item]
        cell.contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAnswer = items[indexPath.item]
        compareSelectedAnswer(selectedAnswer)
    }
    
    func compareSelectedAnswer(_ selectedAnswer: String) {
        if selectedAnswer == selectedItem {
            print("Correct answer!")
            scores[spyName, default: 0] += 100
        } else {
            print("Incorrect answer!")
            scores[spyName, default: 0] -= 25
        }
        
        performSegue(withIdentifier: "scoreVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // You can use this method to pass data to the destination view controller
        if segue.identifier == "scoreVC" {
            // Example: Pass the scores dictionary to the next view controller
            if let scoreViewController = segue.destination as? ScoreViewController {
                scoreViewController.scores = scores
                scoreViewController.playerNames = playerNames
            }
        }
    }
}
