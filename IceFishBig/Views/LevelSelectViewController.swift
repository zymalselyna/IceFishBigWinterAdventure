import UIKit

protocol LevelSelectDelegate: AnyObject {
    func didSelectLevel(_ level: LevelConfig)
    func didTapBackFromLevelSelect()
}

final class LevelSelectViewController: UIViewController {
    weak var delegate: LevelSelectDelegate?
    private let levels = LevelConfig.allLevels
    private let viewModel = GameViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.1, green: 0.15, blue: 0.25, alpha: 1.0)
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.setTitle(" Back", for: .normal)
        backButton.tintColor = .white
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        view.addSubview(backButton)
        
        let titleLabel = UILabel()
        titleLabel.text = "Select Level"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        for level in levels {
            let card = createLevelCard(level: level)
            stackView.addArrangedSubview(card)
        }
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func createLevelCard(level: LevelConfig) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor(white: 1, alpha: 0.08)
        card.layer.cornerRadius = 16
        card.layer.borderWidth = 2
        card.layer.borderColor = levelBorderColor(level.id).cgColor
        card.tag = level.id
        card.translatesAutoresizingMaskIntoConstraints = false
        card.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(levelCardTapped(_:)))
        card.addGestureRecognizer(tap)
        
        let levelNumber = UILabel()
        levelNumber.text = "\(level.id + 1)"
        levelNumber.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        levelNumber.textColor = levelBorderColor(level.id)
        levelNumber.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(levelNumber)
        
        let nameLabel = UILabel()
        nameLabel.text = level.name
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(nameLabel)
        
        let stats = viewModel.statsForLevel(level.id)
        let detailLabel = UILabel()
        detailLabel.text = "Time: \(level.duration)s  |  Fish types: \(level.fishes.count)"
        detailLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        detailLabel.textColor = UIColor(white: 0.7, alpha: 1)
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(detailLabel)
        
        let highScoreLabel = UILabel()
        highScoreLabel.text = stats.highScore > 0 ? "Best: \(stats.highScore)" : "Not played"
        highScoreLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        highScoreLabel.textColor = stats.highScore > 0 ? UIColor(red: 0.3, green: 0.9, blue: 0.5, alpha: 1) : .gray
        highScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(highScoreLabel)
        
        let arrowIcon = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrowIcon.tintColor = .gray
        arrowIcon.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(arrowIcon)
        
        NSLayoutConstraint.activate([
            levelNumber.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            levelNumber.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            levelNumber.widthAnchor.constraint(equalToConstant: 50),
            
            nameLabel.leadingAnchor.constraint(equalTo: levelNumber.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            
            detailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            
            highScoreLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            highScoreLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 6),
            
            arrowIcon.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            arrowIcon.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            arrowIcon.widthAnchor.constraint(equalToConstant: 12),
            arrowIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return card
    }
    
    private func levelBorderColor(_ id: Int) -> UIColor {
        let colors: [UIColor] = [
            UIColor(red: 0.3, green: 0.7, blue: 1.0, alpha: 1.0),
            UIColor(red: 0.4, green: 0.8, blue: 0.5, alpha: 1.0),
            UIColor(red: 0.9, green: 0.5, blue: 0.3, alpha: 1.0),
            UIColor(red: 0.7, green: 0.4, blue: 0.9, alpha: 1.0),
            UIColor(red: 1.0, green: 0.3, blue: 0.5, alpha: 1.0)
        ]
        return colors[id % colors.count]
    }
    
    @objc private func levelCardTapped(_ gesture: UITapGestureRecognizer) {
        guard let tag = gesture.view?.tag else { return }
        HapticManager.shared.buttonTap()
        let level = levels[tag]
        delegate?.didSelectLevel(level)
    }
    
    @objc private func backTapped() {
        HapticManager.shared.buttonTap()
        delegate?.didTapBackFromLevelSelect()
    }
}
