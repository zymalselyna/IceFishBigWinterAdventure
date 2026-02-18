import UIKit

final class StatsViewController: UIViewController {
    private let viewModel = GameViewModel()
    private let levels = LevelConfig.allLevels
    private var tableView: UITableView!
    private var overallContainer: UIView!
    private var gamesValueLabel: UILabel!
    private var fishValueLabel: UILabel!
    private var bestValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(statsChanged), name: .statsDidUpdate, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @objc private func statsChanged() {
        viewModel.reloadFromDisk()
        refreshData()
    }
    
    private func refreshData() {
        gamesValueLabel.text = "\(viewModel.totalGamesPlayed)"
        fishValueLabel.text = "\(viewModel.totalFishCaught)"
        bestValueLabel.text = "\(viewModel.overallHighScore)"
        tableView.reloadData()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.1, green: 0.15, blue: 0.25, alpha: 1.0)
        
        let titleLabel = UILabel()
        titleLabel.text = "Statistics"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        overallContainer = createOverallStatsView()
        overallContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overallContainer)
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LevelStatsCell.self, forCellReuseIdentifier: "LevelStatsCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            overallContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            overallContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overallContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: overallContainer.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func createOverallStatsView() -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(red: 0.15, green: 0.2, blue: 0.35, alpha: 1.0)
        container.layer.cornerRadius = 16
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)
        
        let (gamesItem, gamesVal) = createStatItem(value: "\(viewModel.totalGamesPlayed)", label: "Games")
        let (fishItem, fishVal) = createStatItem(value: "\(viewModel.totalFishCaught)", label: "Fish Caught")
        let (bestItem, bestVal) = createStatItem(value: "\(viewModel.overallHighScore)", label: "Best Score")
        
        gamesValueLabel = gamesVal
        fishValueLabel = fishVal
        bestValueLabel = bestVal
        
        stack.addArrangedSubview(gamesItem)
        stack.addArrangedSubview(fishItem)
        stack.addArrangedSubview(bestItem)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8)
        ])
        
        return container
    }
    
    private func createStatItem(value: String, label: String) -> (UIView, UILabel) {
        let container = UIView()
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        valueLabel.textColor = UIColor(red: 0.3, green: 0.8, blue: 1.0, alpha: 1.0)
        valueLabel.textAlignment = .center
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(valueLabel)
        
        let titleLabel = UILabel()
        titleLabel.text = label
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: container.topAnchor),
            valueLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return (container, valueLabel)
    }
}

extension StatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LevelStatsCell", for: indexPath) as! LevelStatsCell
        let level = levels[indexPath.row]
        let stats = viewModel.statsForLevel(level.id)
        cell.configure(levelName: level.name, levelId: level.id, stats: stats)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

final class LevelStatsCell: UITableViewCell {
    private let containerView = UIView()
    private let levelNameLabel = UILabel()
    private let gamesLabel = UILabel()
    private let highScoreLabel = UILabel()
    private let fishLabel = UILabel()
    private let levelIcon = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = UIColor(white: 1, alpha: 0.06)
        containerView.layer.cornerRadius = 14
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        levelIcon.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        levelIcon.textAlignment = .center
        levelIcon.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(levelIcon)
        
        levelNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        levelNameLabel.textColor = .white
        levelNameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(levelNameLabel)
        
        let detailStack = UIStackView()
        detailStack.axis = .horizontal
        detailStack.spacing = 20
        detailStack.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(detailStack)
        
        gamesLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        gamesLabel.textColor = .gray
        detailStack.addArrangedSubview(gamesLabel)
        
        highScoreLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        highScoreLabel.textColor = UIColor(red: 0.3, green: 0.8, blue: 1.0, alpha: 1.0)
        detailStack.addArrangedSubview(highScoreLabel)
        
        fishLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        fishLabel.textColor = UIColor(red: 0.3, green: 0.9, blue: 0.5, alpha: 1)
        detailStack.addArrangedSubview(fishLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            levelIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            levelIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            levelIcon.widthAnchor.constraint(equalToConstant: 44),
            
            levelNameLabel.leadingAnchor.constraint(equalTo: levelIcon.trailingAnchor, constant: 12),
            levelNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            levelNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            detailStack.leadingAnchor.constraint(equalTo: levelNameLabel.leadingAnchor),
            detailStack.topAnchor.constraint(equalTo: levelNameLabel.bottomAnchor, constant: 10)
        ])
    }
    
    func configure(levelName: String, levelId: Int, stats: LevelStats) {
        levelNameLabel.text = levelName
        levelIcon.text = "\(levelId + 1)"
        
        let colors: [UIColor] = [
            UIColor(red: 0.3, green: 0.7, blue: 1.0, alpha: 1.0),
            UIColor(red: 0.4, green: 0.8, blue: 0.5, alpha: 1.0),
            UIColor(red: 0.9, green: 0.5, blue: 0.3, alpha: 1.0),
            UIColor(red: 0.7, green: 0.4, blue: 0.9, alpha: 1.0),
            UIColor(red: 1.0, green: 0.3, blue: 0.5, alpha: 1.0)
        ]
        levelIcon.textColor = colors[levelId % colors.count]
        
        if stats.gamesPlayed > 0 {
            gamesLabel.text = "Played: \(stats.gamesPlayed)"
            highScoreLabel.text = "Best: \(stats.highScore)"
            fishLabel.text = "Fish: \(stats.totalFishCaught)"
        } else {
            gamesLabel.text = "Not played yet"
            highScoreLabel.text = ""
            fishLabel.text = ""
        }
    }
}
