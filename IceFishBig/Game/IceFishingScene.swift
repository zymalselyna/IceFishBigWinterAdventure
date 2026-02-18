import SpriteKit

protocol IceFishingDelegate: AnyObject {
    func gameDidEnd(score: Int, fishCaught: Int, levelId: Int, timeUsed: Int)
    func didTapBack()
}

final class IceFishingScene: SKScene {
    weak var gameDelegate: IceFishingDelegate?
    var viewModel: GameViewModel?
    var levelConfig: LevelConfig!
    
    private var fisherman: SKSpriteNode!
    private var fishingLine: SKShapeNode!
    private var hook: SKShapeNode!
    private var scoreLabel: SKLabelNode!
    private var timerLabel: SKLabelNode!
    private var backButton: SKShapeNode!
    
    private var score: Int = 0
    private var fishCaughtCount: Int = 0
    private var timeRemaining: Int = 60
    private var timeUsed: Int = 0
    private var gameTimer: Timer?
    private var isFishing: Bool = false
    private var isGameOver: Bool = false
    private var hookDepth: CGFloat = 0
    private var maxHookDepth: CGFloat = 0
    private var fishes: [SKNode] = []
    private var iceHole: SKShapeNode!
    private let haptic = HapticManager.shared
    
    override func didMove(to view: SKView) {
        timeRemaining = levelConfig.duration
        maxHookDepth = size.height * 0.5
        
        setupBackground()
        setupUI()
        setupFisherman()
        setupFishingLine()
        spawnFishes()
        startGameTimer()
    }
    
    private func setupBackground() {
        let colors = levelConfig.colors
        
        let skyGradient = SKSpriteNode(color: .clear, size: CGSize(width: size.width, height: size.height * 0.4))
        skyGradient.position = CGPoint(x: size.width / 2, y: size.height * 0.8)
        skyGradient.zPosition = -10
        skyGradient.texture = createGradientTexture(topColor: colors.skyTop, bottomColor: colors.skyBottom, size: skyGradient.size)
        addChild(skyGradient)
        
        let iceLayer = SKShapeNode(rectOf: CGSize(width: size.width, height: size.height * 0.15))
        iceLayer.fillColor = colors.iceColor
        iceLayer.strokeColor = .clear
        iceLayer.position = CGPoint(x: size.width / 2, y: size.height * 0.525)
        iceLayer.zPosition = -5
        addChild(iceLayer)
        
        let waterGradient = SKSpriteNode(color: .clear, size: CGSize(width: size.width, height: size.height * 0.45))
        waterGradient.position = CGPoint(x: size.width / 2, y: size.height * 0.225)
        waterGradient.zPosition = -8
        waterGradient.texture = createGradientTexture(topColor: colors.waterTop, bottomColor: colors.waterBottom, size: waterGradient.size)
        addChild(waterGradient)
        
        iceHole = SKShapeNode(ellipseOf: CGSize(width: 60, height: 30))
        iceHole.fillColor = colors.waterTop
        iceHole.strokeColor = SKColor(red: 0.7, green: 0.85, blue: 0.95, alpha: 1.0)
        iceHole.lineWidth = 3
        iceHole.position = CGPoint(x: size.width / 2, y: size.height * 0.48)
        iceHole.zPosition = 0
        addChild(iceHole)
        
        createSimpleSnow()
    }
    
    private func createGradientTexture(topColor: SKColor, bottomColor: SKColor, size: CGSize) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            let colors = [topColor.cgColor, bottomColor.cgColor] as CFArray
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: [0, 1]) else { return }
            ctx.cgContext.drawLinearGradient(
                gradient,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: 0, y: size.height),
                options: []
            )
        }
        return SKTexture(image: image)
    }
    
    private func createSimpleSnow() {
        let emitter = SKEmitterNode()
        emitter.particleBirthRate = 15
        emitter.particleLifetime = 8
        emitter.particlePositionRange = CGVector(dx: size.width, dy: 0)
        emitter.particleSpeed = 40
        emitter.particleSpeedRange = 20
        emitter.emissionAngle = .pi * 1.5
        emitter.emissionAngleRange = 0.2
        emitter.particleAlpha = 0.7
        emitter.particleAlphaRange = 0.3
        emitter.particleScale = 0.08
        emitter.particleScaleRange = 0.04
        emitter.particleColor = .white
        emitter.particleColorBlendFactor = 1.0
        
        let circle = SKShapeNode(circleOfRadius: 5)
        circle.fillColor = .white
        circle.strokeColor = .clear
        let texture = view?.texture(from: circle)
        emitter.particleTexture = texture
        
        emitter.position = CGPoint(x: size.width / 2, y: size.height)
        emitter.zPosition = 20
        addChild(emitter)
    }
    
    private func setupUI() {
        let scoreBackground = SKShapeNode(rectOf: CGSize(width: 120, height: 40), cornerRadius: 10)
        scoreBackground.fillColor = SKColor(white: 0, alpha: 0.5)
        scoreBackground.strokeColor = .clear
        scoreBackground.position = CGPoint(x: 70, y: size.height - 50)
        scoreBackground.zPosition = 100
        addChild(scoreBackground)
        
        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = .white
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.zPosition = 101
        scoreBackground.addChild(scoreLabel)
        
        let timerBackground = SKShapeNode(rectOf: CGSize(width: 100, height: 40), cornerRadius: 10)
        timerBackground.fillColor = SKColor(white: 0, alpha: 0.5)
        timerBackground.strokeColor = .clear
        timerBackground.position = CGPoint(x: size.width - 60, y: size.height - 50)
        timerBackground.zPosition = 100
        addChild(timerBackground)
        
        timerLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        timerLabel.text = "\(timeRemaining)s"
        timerLabel.fontSize = 20
        timerLabel.fontColor = .white
        timerLabel.horizontalAlignmentMode = .center
        timerLabel.verticalAlignmentMode = .center
        timerLabel.zPosition = 101
        timerBackground.addChild(timerLabel)
        
        backButton = SKShapeNode(rectOf: CGSize(width: 80, height: 35), cornerRadius: 8)
        backButton.fillColor = SKColor(red: 0.8, green: 0.3, blue: 0.3, alpha: 0.8)
        backButton.strokeColor = .white
        backButton.lineWidth = 2
        backButton.position = CGPoint(x: size.width / 2, y: size.height - 50)
        backButton.zPosition = 100
        backButton.name = "backButton"
        addChild(backButton)
        
        let backLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        backLabel.text = "MENU"
        backLabel.fontSize = 16
        backLabel.fontColor = .white
        backLabel.horizontalAlignmentMode = .center
        backLabel.verticalAlignmentMode = .center
        backLabel.name = "backButton"
        backButton.addChild(backLabel)
        
        let levelNameLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        levelNameLabel.text = levelConfig.name
        levelNameLabel.fontSize = 16
        levelNameLabel.fontColor = SKColor(white: 0.8, alpha: 1.0)
        levelNameLabel.position = CGPoint(x: size.width / 2, y: size.height - 85)
        levelNameLabel.zPosition = 100
        addChild(levelNameLabel)
    }
    
    private func setupFisherman() {
        fisherman = SKSpriteNode(color: .clear, size: CGSize(width: 60, height: 80))
        fisherman.position = CGPoint(x: size.width / 2, y: size.height * 0.58)
        fisherman.zPosition = 5
        
        let body = SKShapeNode(rectOf: CGSize(width: 30, height: 40), cornerRadius: 5)
        body.fillColor = SKColor(red: 0.2, green: 0.4, blue: 0.7, alpha: 1.0)
        body.strokeColor = .clear
        body.position = CGPoint(x: 0, y: -10)
        fisherman.addChild(body)
        
        let head = SKShapeNode(circleOfRadius: 12)
        head.fillColor = SKColor(red: 0.95, green: 0.8, blue: 0.7, alpha: 1.0)
        head.strokeColor = .clear
        head.position = CGPoint(x: 0, y: 20)
        fisherman.addChild(head)
        
        let hat = SKShapeNode(rectOf: CGSize(width: 28, height: 15), cornerRadius: 3)
        hat.fillColor = SKColor(red: 0.6, green: 0.2, blue: 0.2, alpha: 1.0)
        hat.strokeColor = .clear
        hat.position = CGPoint(x: 0, y: 32)
        fisherman.addChild(hat)
        
        let rod = SKShapeNode(rectOf: CGSize(width: 4, height: 50))
        rod.fillColor = SKColor(red: 0.4, green: 0.25, blue: 0.15, alpha: 1.0)
        rod.strokeColor = .clear
        rod.position = CGPoint(x: 20, y: 10)
        rod.zRotation = -0.3
        rod.name = "rod"
        fisherman.addChild(rod)
        
        addChild(fisherman)
    }
    
    private func setupFishingLine() {
        fishingLine = SKShapeNode()
        fishingLine.strokeColor = .white
        fishingLine.lineWidth = 1.5
        fishingLine.zPosition = 3
        addChild(fishingLine)
        
        hook = SKShapeNode(circleOfRadius: 8)
        hook.fillColor = SKColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        hook.strokeColor = .white
        hook.lineWidth = 2
        hook.position = CGPoint(x: size.width / 2, y: size.height * 0.48)
        hook.zPosition = 4
        hook.name = "hook"
        
        let hookShape = SKShapeNode()
        let hookPath = CGMutablePath()
        hookPath.move(to: CGPoint(x: 0, y: 5))
        hookPath.addLine(to: CGPoint(x: 0, y: -3))
        hookPath.addQuadCurve(to: CGPoint(x: 5, y: 2), control: CGPoint(x: 5, y: -5))
        hookShape.path = hookPath
        hookShape.strokeColor = .gray
        hookShape.lineWidth = 2
        hook.addChild(hookShape)
        
        addChild(hook)
        updateFishingLine()
    }
    
    private func updateFishingLine() {
        let startPoint = CGPoint(x: fisherman.position.x + 30, y: fisherman.position.y + 25)
        let endPoint = hook.position
        
        let path = CGMutablePath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        fishingLine.path = path
    }
    
    private func spawnFishes() {
        let fishTypes = levelConfig.fishes
        
        for _ in 0..<levelConfig.fishCount {
            let fishType = fishTypes.randomElement()!
            let fish = createFish(color: fishType.color, size: fishType.size)
            fish.userData = NSMutableDictionary()
            fish.userData?["points"] = fishType.points
            fish.userData?["speed"] = fishType.speed
            fish.userData?["name"] = fishType.name
            
            let yRange = size.height * 0.05...size.height * 0.4
            fish.position = CGPoint(
                x: CGFloat.random(in: 50...(size.width - 50)),
                y: CGFloat.random(in: yRange)
            )
            fish.zPosition = 2
            fish.name = "fish"
            
            addChild(fish)
            fishes.append(fish)
            
            animateFish(fish, speed: fishType.speed)
        }
    }
    
    private func createFish(color: SKColor, size: CGSize) -> SKShapeNode {
        let fish = SKShapeNode()
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: -size.width / 2, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: size.width / 2 - 10, y: 0),
            control: CGPoint(x: 0, y: size.height / 2)
        )
        path.addQuadCurve(
            to: CGPoint(x: -size.width / 2, y: 0),
            control: CGPoint(x: 0, y: -size.height / 2)
        )
        
        path.move(to: CGPoint(x: size.width / 2 - 10, y: 0))
        path.addLine(to: CGPoint(x: size.width / 2 + 5, y: size.height / 3))
        path.addLine(to: CGPoint(x: size.width / 2 + 5, y: -size.height / 3))
        path.closeSubpath()
        
        fish.path = path
        fish.fillColor = color
        fish.strokeColor = color.withAlphaComponent(0.8)
        fish.lineWidth = 1
        
        let eye = SKShapeNode(circleOfRadius: 3)
        eye.fillColor = .white
        eye.strokeColor = .black
        eye.lineWidth = 1
        eye.position = CGPoint(x: -size.width / 4, y: size.height / 6)
        fish.addChild(eye)
        
        return fish
    }
    
    private func animateFish(_ fish: SKNode, speed: CGFloat) {
        let direction: CGFloat = Bool.random() ? 1 : -1
        fish.xScale = -direction
        
        let moveDistance = size.width + 100
        let duration = TimeInterval(moveDistance / speed)
        
        let startX = direction > 0 ? -50 : size.width + 50
        fish.position.x = startX
        
        let moveAction = SKAction.moveBy(x: direction * moveDistance, y: 0, duration: duration)
        let resetAction = SKAction.run { [weak self, weak fish] in
            guard let self = self, let fish = fish else { return }
            let newDirection: CGFloat = Bool.random() ? 1 : -1
            fish.xScale = -newDirection
            fish.position.x = newDirection > 0 ? -50 : self.size.width + 50
            let yRange = self.size.height * 0.05...self.size.height * 0.4
            fish.position.y = CGFloat.random(in: yRange)
        }
        
        let sequence = SKAction.sequence([moveAction, resetAction])
        fish.run(SKAction.repeatForever(sequence), withKey: "swim")
        
        let bobAction = SKAction.sequence([
            SKAction.moveBy(x: 0, y: 10, duration: 1.0),
            SKAction.moveBy(x: 0, y: -10, duration: 1.0)
        ])
        fish.run(SKAction.repeatForever(bobAction), withKey: "bob")
    }
    
    private func startGameTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeRemaining -= 1
            self.timeUsed += 1
            self.timerLabel.text = "\(self.timeRemaining)s"
            
            if self.timeRemaining <= 10 {
                self.timerLabel.fontColor = .red
                self.haptic.timerWarning()
            }
            
            if self.timeRemaining <= 0 {
                self.endGame()
            }
        }
    }
    
    private func endGame() {
        isGameOver = true
        isFishing = false
        gameTimer?.invalidate()
        gameTimer = nil
        haptic.gameOver()
        
        let overlay = SKShapeNode(rectOf: size)
        overlay.fillColor = SKColor(white: 0, alpha: 0.7)
        overlay.strokeColor = .clear
        overlay.position = CGPoint(x: size.width / 2, y: size.height / 2)
        overlay.zPosition = 200
        addChild(overlay)
        
        let gameOverLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        gameOverLabel.text = "Game Over!"
        gameOverLabel.fontSize = 48
        gameOverLabel.fontColor = .white
        gameOverLabel.position = CGPoint(x: 0, y: 50)
        overlay.addChild(gameOverLabel)
        
        let finalScoreLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        finalScoreLabel.text = "Final Score: \(score)"
        finalScoreLabel.fontSize = 32
        finalScoreLabel.fontColor = SKColor(red: 0.3, green: 0.8, blue: 1.0, alpha: 1.0)
        finalScoreLabel.position = CGPoint(x: 0, y: -20)
        overlay.addChild(finalScoreLabel)
        
        let fishCaughtLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
        fishCaughtLabel.text = "Fish Caught: \(fishCaughtCount)"
        fishCaughtLabel.fontSize = 24
        fishCaughtLabel.fontColor = SKColor(red: 0.3, green: 0.9, blue: 0.5, alpha: 1.0)
        fishCaughtLabel.position = CGPoint(x: 0, y: -60)
        overlay.addChild(fishCaughtLabel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            guard let self = self else { return }
            self.gameDelegate?.gameDidEnd(
                score: self.score,
                fishCaught: self.fishCaughtCount,
                levelId: self.levelConfig.id,
                timeUsed: self.timeUsed
            )
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isGameOver else { return }
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        for node in touchedNodes {
            if node.name == "backButton" {
                haptic.buttonTap()
                gameTimer?.invalidate()
                gameDelegate?.didTapBack()
                return
            }
        }
        
        if !isFishing {
            startFishing()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isGameOver else { return }
        if isFishing {
            stopFishing()
        }
    }
    
    private func startFishing() {
        isFishing = true
        haptic.hookDropped()
        
        let lowerAction = SKAction.customAction(withDuration: 2.0) { [weak self] _, elapsedTime in
            guard let self = self else { return }
            let progress = elapsedTime / 2.0
            let newY = self.size.height * 0.48 - (self.maxHookDepth * progress)
            self.hook.position.y = newY
            self.hookDepth = self.maxHookDepth * progress
            self.updateFishingLine()
            self.checkFishCatch()
        }
        
        hook.run(lowerAction, withKey: "fishing")
    }
    
    private func stopFishing() {
        isFishing = false
        hook.removeAction(forKey: "fishing")
        
        let returnAction = SKAction.moveTo(y: size.height * 0.48, duration: 0.5)
        returnAction.timingMode = .easeOut
        
        hook.run(returnAction) { [weak self] in
            self?.hookDepth = 0
            self?.updateFishingLine()
        }
        
        let updateLineAction = SKAction.customAction(withDuration: 0.5) { [weak self] _, _ in
            self?.updateFishingLine()
        }
        hook.run(updateLineAction)
    }
    
    private func checkFishCatch() {
        let hookFrame = hook.frame.insetBy(dx: -15, dy: -15)
        
        for fish in fishes {
            guard let fishNode = fish as? SKShapeNode else { continue }
            
            if hookFrame.intersects(fishNode.frame) {
                catchFish(fishNode)
                break
            }
        }
    }
    
    private func catchFish(_ fish: SKShapeNode) {
        fish.removeAllActions()
        haptic.fishCaught()
        
        let points = fish.userData?["points"] as? Int ?? 10
        score += points
        fishCaughtCount += 1
        scoreLabel.text = "Score: \(score)"
        
        showPointsPopup(points: points, at: fish.position)
        
        let catchAction = SKAction.sequence([
            SKAction.group([
                SKAction.scale(to: 0, duration: 0.3),
                SKAction.fadeOut(withDuration: 0.3)
            ]),
            SKAction.run { [weak self, weak fish] in
                guard let self = self, let fish = fish else { return }
                fish.removeFromParent()
                if let index = self.fishes.firstIndex(where: { $0 === fish }) {
                    self.fishes.remove(at: index)
                }
                self.spawnNewFish()
            }
        ])
        
        fish.run(catchAction)
        stopFishing()
    }
    
    private func showPointsPopup(points: Int, at position: CGPoint) {
        let popup = SKLabelNode(fontNamed: "AvenirNext-Bold")
        popup.text = "+\(points)"
        popup.fontSize = 24
        popup.fontColor = SKColor(red: 0.3, green: 1.0, blue: 0.3, alpha: 1.0)
        popup.position = position
        popup.zPosition = 150
        addChild(popup)
        
        let moveUp = SKAction.moveBy(x: 0, y: 50, duration: 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let group = SKAction.group([moveUp, fadeOut])
        let remove = SKAction.removeFromParent()
        
        popup.run(SKAction.sequence([group, remove]))
    }
    
    private func spawnNewFish() {
        let fishTypes = levelConfig.fishes
        let fishType = fishTypes.randomElement()!
        let fish = createFish(color: fishType.color, size: fishType.size)
        fish.userData = NSMutableDictionary()
        fish.userData?["points"] = fishType.points
        fish.userData?["speed"] = fishType.speed
        fish.userData?["name"] = fishType.name
        
        let yRange = size.height * 0.05...size.height * 0.4
        fish.position = CGPoint(x: -50, y: CGFloat.random(in: yRange))
        fish.zPosition = 2
        fish.name = "fish"
        fish.alpha = 0
        
        addChild(fish)
        fishes.append(fish)
        
        fish.run(SKAction.fadeIn(withDuration: 0.3))
        animateFish(fish, speed: fishType.speed)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isFishing {
            updateFishingLine()
        }
    }
    
    override func willMove(from view: SKView) {
        gameTimer?.invalidate()
        gameTimer = nil
    }
}
