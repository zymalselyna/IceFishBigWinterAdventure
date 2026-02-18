import UIKit
import StoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let viewModel = RootViewModel()
    private var orientationLock: UIInterfaceOrientationMask = .portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.register(defaults: ["vibrationEnabled": true])
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let launchVC = createLaunchController()
        window?.rootViewController = launchVC
        
        checkInitialDestination()
        
        return true
    }
    
    private func createLaunchController() -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .black
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        vc.view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)
        ])
        
        return vc
    }
    
    private func checkInitialDestination() {
        viewModel.checkInitialState { [weak self] destination in
            guard let self = self else { return }
            
            switch destination {
            case .remoteContent(let link):
                self.showRemoteContent(link: link)
                if self.viewModel.wasTokenPreloaded && !UserDefaults.standard.bool(forKey: "reviewRequested") {
                    UserDefaults.standard.set(true, forKey: "reviewRequested")
                    self.requestAppReview()
                }
            case .gameTabBar:
                self.showGameTabBar()
            }
        }
    }
    
    private func showRemoteContent(link: String) {
        orientationLock = .all
        let remoteVC = RemoteContentViewController(link: link)
        window?.rootViewController = remoteVC
    }
    
    private func showGameTabBar() {
        orientationLock = .portrait
        let tabBar = MainTabBarController()
        window?.rootViewController = tabBar
    }
    
    private func requestAppReview() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let scene = self?.window?.windowScene else { return }
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }
}
