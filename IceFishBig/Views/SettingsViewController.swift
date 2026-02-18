import UIKit

final class SettingsViewController: UIViewController {
    private var vibrationEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
        setupUI()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.1, green: 0.15, blue: 0.25, alpha: 1.0)
        
        let titleLabel = UILabel()
        titleLabel.text = "Settings"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let vibrationRow = createSettingRow(title: "Vibration", icon: "iphone.radiowaves.left.and.right", isOn: vibrationEnabled, action: #selector(vibrationToggled))
        vibrationRow.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vibrationRow)
        
        let resetButton = UIButton(type: .system)
        resetButton.setTitle("Reset Progress", for: .normal)
        resetButton.setTitleColor(.red, for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        resetButton.backgroundColor = UIColor(white: 1, alpha: 0.1)
        resetButton.layer.cornerRadius = 12
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.addTarget(self, action: #selector(resetProgressTapped), for: .touchUpInside)
        view.addSubview(resetButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            vibrationRow.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            vibrationRow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            vibrationRow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            resetButton.topAnchor.constraint(equalTo: vibrationRow.bottomAnchor, constant: 40),
            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resetButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func createSettingRow(title: String, icon: String, isOn: Bool, action: Selector) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(white: 1, alpha: 0.1)
        container.layer.cornerRadius = 12
        container.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = UIColor(red: 0.3, green: 0.7, blue: 1.0, alpha: 1.0)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(iconView)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)
        
        let toggle = UISwitch()
        toggle.isOn = isOn
        toggle.onTintColor = UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
        toggle.addTarget(self, action: action, for: .valueChanged)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(toggle)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            toggle.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            toggle.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        return container
    }
    
    private func loadSettings() {
        if !UserDefaults.standard.bool(forKey: "settingsInitialized") {
            vibrationEnabled = true
            UserDefaults.standard.set(true, forKey: "settingsInitialized")
            UserDefaults.standard.set(vibrationEnabled, forKey: "vibrationEnabled")
        } else {
            vibrationEnabled = UserDefaults.standard.bool(forKey: "vibrationEnabled")
        }
    }
    
    @objc private func vibrationToggled(_ sender: UISwitch) {
        vibrationEnabled = sender.isOn
        UserDefaults.standard.set(vibrationEnabled, forKey: "vibrationEnabled")
    }
    
    @objc private func resetProgressTapped() {
        let alert = UIAlertController(
            title: "Reset Progress",
            message: "Are you sure you want to reset all your progress? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive) { _ in
            let vm = GameViewModel()
            vm.resetAllStats()
            
            let confirmAlert = UIAlertController(title: "Done", message: "Your progress has been reset.", preferredStyle: .alert)
            confirmAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(confirmAlert, animated: true)
        })
        
        present(alert, animated: true)
    }
}
