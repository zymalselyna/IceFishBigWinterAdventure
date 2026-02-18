import UIKit
import SpriteKit

final class GameHostController: UIViewController {
    private var skView: SKView!
    private let viewModel = GameViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGameView()
        presentMainMenu()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupGameView() {
        skView = SKView(frame: view.bounds)
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        skView.ignoresSiblingOrder = true
        view.addSubview(skView)
    }
    
    private func presentMainMenu() {
        tabBarController?.tabBar.isHidden = false
        let scene = MainMenuScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        scene.menuDelegate = self
        skView.presentScene(scene)
    }
    
    private func showLevelSelect() {
        let levelSelectVC = LevelSelectViewController()
        levelSelectVC.delegate = self
        levelSelectVC.modalPresentationStyle = .fullScreen
        present(levelSelectVC, animated: true)
    }
    
    private func startGame(level: LevelConfig) {
        tabBarController?.tabBar.isHidden = true
        let scene = IceFishingScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        scene.gameDelegate = self
        scene.viewModel = viewModel
        scene.levelConfig = level
        skView.presentScene(scene, transition: SKTransition.fade(withDuration: 0.5))
    }
}

extension GameHostController: MainMenuDelegate {
    func didTapPlay() {
        HapticManager.shared.buttonTap()
        showLevelSelect()
    }
}

extension GameHostController: LevelSelectDelegate {
    func didSelectLevel(_ level: LevelConfig) {
        dismiss(animated: true) { [weak self] in
            self?.startGame(level: level)
        }
    }
    
    func didTapBackFromLevelSelect() {
        dismiss(animated: true)
    }
}

extension GameHostController: IceFishingDelegate {
    func gameDidEnd(score: Int, fishCaught: Int, levelId: Int, timeUsed: Int) {
        viewModel.saveGameResult(levelId: levelId, score: score, fishCaught: fishCaught, timeUsed: timeUsed)
        presentMainMenu()
    }
    
    func didTapBack() {
        presentMainMenu()
    }
}
