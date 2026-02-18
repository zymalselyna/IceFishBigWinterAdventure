import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lockPortraitOrientation()
    }
    
    private func lockPortraitOrientation() {
        guard let windowScene = view.window?.windowScene else { return }
        let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: .portrait)
        windowScene.requestGeometryUpdate(geometryPreferences) { _ in }
        setNeedsUpdateOfSupportedInterfaceOrientations()
    }
    
    private func setupTabs() {
        let gameVC = GameHostController()
        gameVC.tabBarItem = UITabBarItem(title: "Play", image: UIImage(systemName: "gamecontroller.fill"), tag: 0)
        
        let statsVC = StatsViewController()
        statsVC.tabBarItem = UITabBarItem(title: "Statistics", image: UIImage(systemName: "chart.bar.fill"), tag: 1)
        
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.fill"), tag: 2)
        
        viewControllers = [gameVC, statsVC, settingsVC]
    }
    
    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.1, green: 0.15, blue: 0.25, alpha: 1.0)
        
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
