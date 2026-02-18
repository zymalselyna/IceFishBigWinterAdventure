import SpriteKit

protocol MainMenuDelegate: AnyObject {
    func didTapPlay()
}

final class MainMenuScene: SKScene {
    weak var menuDelegate: MainMenuDelegate?
    
    private var playButton: SKShapeNode!
    private var buttonGlow: SKShapeNode!
    private var titleLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.04, green: 0.06, blue: 0.14, alpha: 1.0)
        setupBackground()
        setupStars()
        setupMountains()
        setupIceGround()
        setupSnowEffect()
        setupWater()
        setupFishermanSilhouette()
        setupTitle()
        setupPlayButton()
        setupSwimmingFishes()
    }
    
    private func setupBackground() {
        let gradient = SKSpriteNode(color: .clear, size: size)
        gradient.position = CGPoint(x: size.width / 2, y: size.height / 2)
        gradient.zPosition = -20
        gradient.texture = createGradientTexture(
            colors: [
                SKColor(red: 0.02, green: 0.03, blue: 0.1, alpha: 1.0),
                SKColor(red: 0.06, green: 0.1, blue: 0.25, alpha: 1.0),
                SKColor(red: 0.1, green: 0.18, blue: 0.38, alpha: 1.0)
            ],
            locations: [0.0, 0.5, 1.0],
            size: size
        )
        addChild(gradient)
    }
    
    private func createGradientTexture(colors: [SKColor], locations: [CGFloat], size: CGSize) -> SKTexture {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            let cgColors = colors.map { $0.cgColor } as CFArray
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: locations) else { return }
            ctx.cgContext.drawLinearGradient(
                gradient,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: 0, y: size.height),
                options: []
            )
        }
        return SKTexture(image: image)
    }
    
    private func setupStars() {
        for _ in 0..<50 {
            let star = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.8...2.0))
            star.fillColor = .white
            star.strokeColor = .clear
            star.position = CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: size.height * 0.55...size.height)
            )
            star.zPosition = -15
            star.alpha = CGFloat.random(in: 0.3...0.9)
            addChild(star)
            
            let twinkle = SKAction.sequence([
                SKAction.fadeAlpha(to: CGFloat.random(in: 0.1...0.4), duration: Double.random(in: 1.0...3.0)),
                SKAction.fadeAlpha(to: CGFloat.random(in: 0.6...1.0), duration: Double.random(in: 1.0...3.0))
            ])
            star.run(SKAction.repeatForever(twinkle))
        }
        
        let moon = SKShapeNode(circleOfRadius: 22)
        moon.fillColor = SKColor(red: 0.95, green: 0.93, blue: 0.8, alpha: 1.0)
        moon.strokeColor = .clear
        moon.position = CGPoint(x: size.width * 0.8, y: size.height * 0.85)
        moon.zPosition = -14
        addChild(moon)
        
        let moonGlow = SKShapeNode(circleOfRadius: 40)
        moonGlow.fillColor = SKColor(red: 0.95, green: 0.93, blue: 0.8, alpha: 0.1)
        moonGlow.strokeColor = .clear
        moonGlow.position = moon.position
        moonGlow.zPosition = -14.5
        addChild(moonGlow)
        
        let moonShadow = SKShapeNode(circleOfRadius: 20)
        moonShadow.fillColor = SKColor(red: 0.04, green: 0.06, blue: 0.14, alpha: 0.5)
        moonShadow.strokeColor = .clear
        moonShadow.position = CGPoint(x: moon.position.x + 8, y: moon.position.y + 5)
        moonShadow.zPosition = -13.5
        addChild(moonShadow)
    }
    
    private func setupMountains() {
        let farMountain = SKShapeNode()
        let farPath = CGMutablePath()
        farPath.move(to: CGPoint(x: 0, y: size.height * 0.42))
        farPath.addLine(to: CGPoint(x: size.width * 0.15, y: size.height * 0.58))
        farPath.addLine(to: CGPoint(x: size.width * 0.3, y: size.height * 0.5))
        farPath.addLine(to: CGPoint(x: size.width * 0.5, y: size.height * 0.65))
        farPath.addLine(to: CGPoint(x: size.width * 0.65, y: size.height * 0.55))
        farPath.addLine(to: CGPoint(x: size.width * 0.85, y: size.height * 0.6))
        farPath.addLine(to: CGPoint(x: size.width, y: size.height * 0.48))
        farPath.addLine(to: CGPoint(x: size.width, y: size.height * 0.42))
        farPath.closeSubpath()
        farMountain.path = farPath
        farMountain.fillColor = SKColor(red: 0.08, green: 0.12, blue: 0.28, alpha: 1.0)
        farMountain.strokeColor = .clear
        farMountain.zPosition = -12
        addChild(farMountain)
        
        let nearMountain = SKShapeNode()
        let nearPath = CGMutablePath()
        nearPath.move(to: CGPoint(x: 0, y: size.height * 0.38))
        nearPath.addLine(to: CGPoint(x: size.width * 0.1, y: size.height * 0.48))
        nearPath.addLine(to: CGPoint(x: size.width * 0.25, y: size.height * 0.44))
        nearPath.addLine(to: CGPoint(x: size.width * 0.4, y: size.height * 0.52))
        nearPath.addLine(to: CGPoint(x: size.width * 0.55, y: size.height * 0.46))
        nearPath.addLine(to: CGPoint(x: size.width * 0.7, y: size.height * 0.5))
        nearPath.addLine(to: CGPoint(x: size.width * 0.9, y: size.height * 0.43))
        nearPath.addLine(to: CGPoint(x: size.width, y: size.height * 0.46))
        nearPath.addLine(to: CGPoint(x: size.width, y: size.height * 0.38))
        nearPath.closeSubpath()
        nearMountain.path = nearPath
        nearMountain.fillColor = SKColor(red: 0.06, green: 0.09, blue: 0.22, alpha: 1.0)
        nearMountain.strokeColor = .clear
        nearMountain.zPosition = -11
        addChild(nearMountain)
        
        let snowCaps = SKShapeNode()
        let snowPath = CGMutablePath()
        snowPath.move(to: CGPoint(x: size.width * 0.47, y: size.height * 0.65))
        snowPath.addLine(to: CGPoint(x: size.width * 0.5, y: size.height * 0.65))
        snowPath.addLine(to: CGPoint(x: size.width * 0.53, y: size.height * 0.63))
        snowPath.addLine(to: CGPoint(x: size.width * 0.47, y: size.height * 0.63))
        snowPath.closeSubpath()
        snowCaps.path = snowPath
        snowCaps.fillColor = SKColor(white: 0.9, alpha: 0.6)
        snowCaps.strokeColor = .clear
        snowCaps.zPosition = -11.5
        addChild(snowCaps)
        
        let treeLine = SKShapeNode()
        let treePath = CGMutablePath()
        let treeBaseY = size.height * 0.38
        treePath.move(to: CGPoint(x: 0, y: treeBaseY))
        var x: CGFloat = 0
        while x < size.width {
            let h = CGFloat.random(in: 15...35)
            let w: CGFloat = CGFloat.random(in: 8...14)
            treePath.addLine(to: CGPoint(x: x, y: treeBaseY))
            treePath.addLine(to: CGPoint(x: x + w / 2, y: treeBaseY + h))
            treePath.addLine(to: CGPoint(x: x + w, y: treeBaseY))
            x += w + CGFloat.random(in: 2...8)
        }
        treePath.addLine(to: CGPoint(x: size.width, y: treeBaseY))
        treePath.addLine(to: CGPoint(x: size.width, y: treeBaseY - 5))
        treePath.addLine(to: CGPoint(x: 0, y: treeBaseY - 5))
        treePath.closeSubpath()
        treeLine.path = treePath
        treeLine.fillColor = SKColor(red: 0.04, green: 0.07, blue: 0.18, alpha: 1.0)
        treeLine.strokeColor = .clear
        treeLine.zPosition = -10
        addChild(treeLine)
    }
    
    private func setupIceGround() {
        let iceGround = SKShapeNode()
        let icePath = CGMutablePath()
        icePath.move(to: CGPoint(x: 0, y: 0))
        icePath.addLine(to: CGPoint(x: 0, y: size.height * 0.38))
        
        let steps = 20
        for i in 0...steps {
            let px = size.width * CGFloat(i) / CGFloat(steps)
            let py = size.height * 0.38 + sin(CGFloat(i) * 0.5) * 3
            icePath.addLine(to: CGPoint(x: px, y: py))
        }
        
        icePath.addLine(to: CGPoint(x: size.width, y: 0))
        icePath.closeSubpath()
        iceGround.path = icePath
        iceGround.zPosition = -8
        
        let iceTexture = createGradientTexture(
            colors: [
                SKColor(red: 0.7, green: 0.82, blue: 0.92, alpha: 1.0),
                SKColor(red: 0.55, green: 0.7, blue: 0.85, alpha: 1.0),
                SKColor(red: 0.4, green: 0.55, blue: 0.72, alpha: 1.0)
            ],
            locations: [0.0, 0.5, 1.0],
            size: CGSize(width: size.width, height: size.height * 0.4)
        )
        
        let iceSprite = SKSpriteNode(texture: iceTexture, size: CGSize(width: size.width, height: size.height * 0.4))
        iceSprite.position = CGPoint(x: size.width / 2, y: size.height * 0.19)
        iceSprite.zPosition = -8
        addChild(iceSprite)
        
        let iceCrack1 = SKShapeNode()
        let crack1 = CGMutablePath()
        crack1.move(to: CGPoint(x: size.width * 0.2, y: size.height * 0.32))
        crack1.addLine(to: CGPoint(x: size.width * 0.25, y: size.height * 0.28))
        crack1.addLine(to: CGPoint(x: size.width * 0.22, y: size.height * 0.24))
        crack1.addLine(to: CGPoint(x: size.width * 0.28, y: size.height * 0.2))
        iceCrack1.path = crack1
        iceCrack1.strokeColor = SKColor(white: 0.85, alpha: 0.4)
        iceCrack1.lineWidth = 1
        iceCrack1.zPosition = -7
        addChild(iceCrack1)
        
        let iceCrack2 = SKShapeNode()
        let crack2 = CGMutablePath()
        crack2.move(to: CGPoint(x: size.width * 0.7, y: size.height * 0.35))
        crack2.addLine(to: CGPoint(x: size.width * 0.75, y: size.height * 0.3))
        crack2.addLine(to: CGPoint(x: size.width * 0.72, y: size.height * 0.26))
        iceCrack2.path = crack2
        iceCrack2.strokeColor = SKColor(white: 0.85, alpha: 0.3)
        iceCrack2.lineWidth = 1
        iceCrack2.zPosition = -7
        addChild(iceCrack2)
        
        for i in 0..<6 {
            let shimmer = SKShapeNode(ellipseOf: CGSize(width: CGFloat.random(in: 30...80), height: CGFloat.random(in: 3...8)))
            shimmer.fillColor = SKColor(white: 1.0, alpha: CGFloat.random(in: 0.03...0.1))
            shimmer.strokeColor = .clear
            shimmer.position = CGPoint(
                x: CGFloat.random(in: 20...(size.width - 20)),
                y: CGFloat.random(in: size.height * 0.1...size.height * 0.36)
            )
            shimmer.zPosition = -6
            addChild(shimmer)
            
            let shimmerAction = SKAction.sequence([
                SKAction.fadeAlpha(to: 0.02, duration: Double.random(in: 2...4)),
                SKAction.fadeAlpha(to: CGFloat.random(in: 0.06...0.12), duration: Double.random(in: 2...4))
            ])
            shimmer.run(SKAction.repeatForever(shimmerAction))
            _ = i
        }
    }
    
    private func setupWater() {
        let holeX = size.width * 0.5
        let holeY = size.height * 0.25
        
        let waterHole = SKShapeNode(ellipseOf: CGSize(width: 80, height: 35))
        waterHole.fillColor = SKColor(red: 0.08, green: 0.18, blue: 0.35, alpha: 1.0)
        waterHole.strokeColor = SKColor(red: 0.6, green: 0.75, blue: 0.9, alpha: 0.7)
        waterHole.lineWidth = 2.5
        waterHole.position = CGPoint(x: holeX, y: holeY)
        waterHole.zPosition = -4
        addChild(waterHole)
        
        let waterShine = SKShapeNode(ellipseOf: CGSize(width: 55, height: 18))
        waterShine.fillColor = SKColor(red: 0.15, green: 0.3, blue: 0.55, alpha: 0.5)
        waterShine.strokeColor = .clear
        waterShine.position = CGPoint(x: holeX, y: holeY + 3)
        waterShine.zPosition = -3.5
        addChild(waterShine)
        
        let rippleAction = SKAction.sequence([
            SKAction.scale(to: 1.05, duration: 1.5),
            SKAction.scale(to: 0.95, duration: 1.5)
        ])
        waterShine.run(SKAction.repeatForever(rippleAction))
    }
    
    private func setupFishermanSilhouette() {
        let fX = size.width * 0.5
        let fY = size.height * 0.38
        
        let body = SKShapeNode(rectOf: CGSize(width: 20, height: 30), cornerRadius: 4)
        body.fillColor = SKColor(red: 0.15, green: 0.25, blue: 0.45, alpha: 1.0)
        body.strokeColor = .clear
        body.position = CGPoint(x: fX, y: fY + 15)
        body.zPosition = -2
        addChild(body)
        
        let head = SKShapeNode(circleOfRadius: 9)
        head.fillColor = SKColor(red: 0.9, green: 0.75, blue: 0.65, alpha: 1.0)
        head.strokeColor = .clear
        head.position = CGPoint(x: fX, y: fY + 39)
        head.zPosition = -2
        addChild(head)
        
        let hat = SKShapeNode(rectOf: CGSize(width: 22, height: 12), cornerRadius: 3)
        hat.fillColor = SKColor(red: 0.6, green: 0.15, blue: 0.15, alpha: 1.0)
        hat.strokeColor = .clear
        hat.position = CGPoint(x: fX, y: fY + 49)
        hat.zPosition = -1.5
        addChild(hat)
        
        let hatBrim = SKShapeNode(rectOf: CGSize(width: 28, height: 4), cornerRadius: 2)
        hatBrim.fillColor = SKColor(red: 0.5, green: 0.12, blue: 0.12, alpha: 1.0)
        hatBrim.strokeColor = .clear
        hatBrim.position = CGPoint(x: fX, y: fY + 43)
        hatBrim.zPosition = -1.5
        addChild(hatBrim)
        
        let rod = SKShapeNode()
        let rodPath = CGMutablePath()
        rodPath.move(to: CGPoint(x: fX + 10, y: fY + 25))
        rodPath.addLine(to: CGPoint(x: fX + 45, y: fY + 65))
        rod.path = rodPath
        rod.strokeColor = SKColor(red: 0.5, green: 0.35, blue: 0.2, alpha: 1.0)
        rod.lineWidth = 3
        rod.zPosition = -1
        addChild(rod)
        
        let line = SKShapeNode()
        let linePath = CGMutablePath()
        linePath.move(to: CGPoint(x: fX + 45, y: fY + 65))
        linePath.addLine(to: CGPoint(x: fX, y: size.height * 0.25))
        line.path = linePath
        line.strokeColor = SKColor(white: 0.8, alpha: 0.5)
        line.lineWidth = 1
        line.zPosition = -1
        addChild(line)
        
        let bobber = SKShapeNode(circleOfRadius: 4)
        bobber.fillColor = SKColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)
        bobber.strokeColor = .white
        bobber.lineWidth = 1
        bobber.position = CGPoint(x: fX, y: size.height * 0.255)
        bobber.zPosition = -0.5
        addChild(bobber)
        
        let bobAction = SKAction.sequence([
            SKAction.moveBy(x: 0, y: 3, duration: 1.2),
            SKAction.moveBy(x: 0, y: -3, duration: 1.2)
        ])
        bobber.run(SKAction.repeatForever(bobAction))
    }
    
    private func setupTitle() {
        let shadowLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        shadowLabel.text = "ICE FISHING"
        shadowLabel.fontSize = 42
        shadowLabel.fontColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        shadowLabel.position = CGPoint(x: size.width / 2 + 2, y: size.height * 0.76 - 2)
        shadowLabel.zPosition = 9
        addChild(shadowLabel)
        
        titleLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        titleLabel.text = "ICE FISHING"
        titleLabel.fontSize = 42
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.76)
        titleLabel.zPosition = 10
        addChild(titleLabel)
        
        let subtitleLabel = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        subtitleLabel.text = "W I N T E R   A D V E N T U R E"
        subtitleLabel.fontSize = 14
        subtitleLabel.fontColor = SKColor(red: 0.55, green: 0.75, blue: 1.0, alpha: 0.9)
        subtitleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.71)
        subtitleLabel.zPosition = 10
        addChild(subtitleLabel)
        
        let dividerLeft = SKShapeNode(rectOf: CGSize(width: 50, height: 1.5))
        dividerLeft.fillColor = SKColor(red: 0.4, green: 0.65, blue: 1.0, alpha: 0.5)
        dividerLeft.strokeColor = .clear
        dividerLeft.position = CGPoint(x: size.width / 2 - 95, y: size.height * 0.715)
        dividerLeft.zPosition = 10
        addChild(dividerLeft)
        
        let dividerRight = SKShapeNode(rectOf: CGSize(width: 50, height: 1.5))
        dividerRight.fillColor = SKColor(red: 0.4, green: 0.65, blue: 1.0, alpha: 0.5)
        dividerRight.strokeColor = .clear
        dividerRight.position = CGPoint(x: size.width / 2 + 95, y: size.height * 0.715)
        dividerRight.zPosition = 10
        addChild(dividerRight)
        
        let snowflakeIcon = SKLabelNode(text: "❄")
        snowflakeIcon.fontSize = 18
        snowflakeIcon.position = CGPoint(x: size.width / 2, y: size.height * 0.675)
        snowflakeIcon.zPosition = 10
        addChild(snowflakeIcon)
        
        let pulseAction = SKAction.sequence([
            SKAction.scale(to: 1.03, duration: 2.0),
            SKAction.scale(to: 1.0, duration: 2.0)
        ])
        titleLabel.run(SKAction.repeatForever(pulseAction))
    }
    
    private func setupPlayButton() {
        let buttonWidth: CGFloat = 220
        let buttonHeight: CGFloat = 60
        let btnY = size.height * 0.56
        
        buttonGlow = SKShapeNode(rectOf: CGSize(width: buttonWidth + 16, height: buttonHeight + 16), cornerRadius: 20)
        buttonGlow.fillColor = SKColor(red: 0.2, green: 0.5, blue: 1.0, alpha: 0.2)
        buttonGlow.strokeColor = .clear
        buttonGlow.position = CGPoint(x: size.width / 2, y: btnY)
        buttonGlow.zPosition = 9
        addChild(buttonGlow)
        
        let glowPulse = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.4, duration: 1.0),
            SKAction.fadeAlpha(to: 0.15, duration: 1.0)
        ])
        buttonGlow.run(SKAction.repeatForever(glowPulse))
        
        playButton = SKShapeNode(rectOf: CGSize(width: buttonWidth, height: buttonHeight), cornerRadius: 16)
        playButton.fillColor = SKColor(red: 0.15, green: 0.45, blue: 0.85, alpha: 1.0)
        playButton.strokeColor = SKColor(red: 0.4, green: 0.7, blue: 1.0, alpha: 0.8)
        playButton.lineWidth = 2
        playButton.position = CGPoint(x: size.width / 2, y: btnY)
        playButton.zPosition = 10
        playButton.name = "playButton"
        addChild(playButton)
        
        let highlight = SKShapeNode(rectOf: CGSize(width: buttonWidth - 10, height: buttonHeight / 2 - 4), cornerRadius: 12)
        highlight.fillColor = SKColor(white: 1.0, alpha: 0.08)
        highlight.strokeColor = .clear
        highlight.position = CGPoint(x: 0, y: 8)
        highlight.zPosition = 10.5
        highlight.name = "playButton"
        playButton.addChild(highlight)
        
        let playLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        playLabel.text = "START GAME"
        playLabel.fontSize = 22
        playLabel.fontColor = .white
        playLabel.verticalAlignmentMode = .center
        playLabel.position = CGPoint.zero
        playLabel.zPosition = 11
        playLabel.name = "playButton"
        playButton.addChild(playLabel)
    }
    
    private func setupSwimmingFishes() {
        let fishColors: [SKColor] = [
            SKColor(red: 0.3, green: 0.7, blue: 0.95, alpha: 0.6),
            SKColor(red: 0.4, green: 0.85, blue: 0.7, alpha: 0.5),
            SKColor(red: 0.9, green: 0.6, blue: 0.3, alpha: 0.5)
        ]
        
        for i in 0..<3 {
            let fishSize = CGSize(width: CGFloat.random(in: 25...40), height: CGFloat.random(in: 12...20))
            let fish = createFish(color: fishColors[i], size: fishSize)
            let yPos = size.height * CGFloat.random(in: 0.06...0.22)
            fish.position = CGPoint(x: CGFloat.random(in: 0...size.width), y: yPos)
            fish.zPosition = -3
            fish.alpha = 0.7
            addChild(fish)
            
            let direction: CGFloat = Bool.random() ? 1 : -1
            fish.xScale = -direction * abs(fish.xScale)
            let moveDistance = size.width + 100
            let speed = CGFloat.random(in: 40...70)
            let duration = TimeInterval(moveDistance / speed)
            
            fish.position.x = direction > 0 ? -40 : size.width + 40
            
            let moveAction = SKAction.moveBy(x: direction * moveDistance, y: 0, duration: duration)
            let resetAction = SKAction.run { [weak self, weak fish] in
                guard let self = self, let fish = fish else { return }
                let nd: CGFloat = Bool.random() ? 1 : -1
                fish.xScale = -nd * abs(fish.xScale)
                fish.position.x = nd > 0 ? -40 : self.size.width + 40
                fish.position.y = self.size.height * CGFloat.random(in: 0.06...0.22)
            }
            fish.run(SKAction.repeatForever(SKAction.sequence([moveAction, resetAction])))
            
            let bob = SKAction.sequence([
                SKAction.moveBy(x: 0, y: 6, duration: Double.random(in: 1.0...1.8)),
                SKAction.moveBy(x: 0, y: -6, duration: Double.random(in: 1.0...1.8))
            ])
            fish.run(SKAction.repeatForever(bob))
        }
    }
    
    private func createFish(color: SKColor, size: CGSize) -> SKShapeNode {
        let fish = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: -size.width / 2, y: 0))
        path.addQuadCurve(to: CGPoint(x: size.width / 2 - 8, y: 0), control: CGPoint(x: 0, y: size.height / 2))
        path.addQuadCurve(to: CGPoint(x: -size.width / 2, y: 0), control: CGPoint(x: 0, y: -size.height / 2))
        path.move(to: CGPoint(x: size.width / 2 - 8, y: 0))
        path.addLine(to: CGPoint(x: size.width / 2 + 4, y: size.height / 3))
        path.addLine(to: CGPoint(x: size.width / 2 + 4, y: -size.height / 3))
        path.closeSubpath()
        fish.path = path
        fish.fillColor = color
        fish.strokeColor = color.withAlphaComponent(0.3)
        fish.lineWidth = 1
        return fish
    }
    
    private func setupSnowEffect() {
        let emitter = SKEmitterNode()
        emitter.particleBirthRate = 30
        emitter.particleLifetime = 12
        emitter.particlePositionRange = CGVector(dx: size.width * 1.2, dy: 0)
        emitter.particleSpeed = 35
        emitter.particleSpeedRange = 25
        emitter.emissionAngle = .pi * 1.5
        emitter.emissionAngleRange = 0.4
        emitter.particleAlpha = 0.85
        emitter.particleAlphaRange = 0.15
        emitter.particleAlphaSpeed = -0.02
        emitter.particleScale = 0.07
        emitter.particleScaleRange = 0.06
        emitter.particleColor = .white
        emitter.particleColorBlendFactor = 1.0
        
        let circle = SKShapeNode(circleOfRadius: 6)
        circle.fillColor = .white
        circle.strokeColor = .clear
        if let texture = view?.texture(from: circle) {
            emitter.particleTexture = texture
        }
        
        emitter.position = CGPoint(x: size.width / 2, y: size.height + 20)
        emitter.zPosition = 15
        addChild(emitter)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        for node in touchedNodes {
            if node.name == "playButton" {
                animateButtonPress()
                return
            }
        }
    }
    
    private func animateButtonPress() {
        HapticManager.shared.buttonTap()
        let scaleDown = SKAction.scale(to: 0.92, duration: 0.08)
        let scaleUp = SKAction.scale(to: 1.0, duration: 0.08)
        let flash = SKAction.run { [weak self] in
            self?.playButton.fillColor = SKColor(red: 0.25, green: 0.55, blue: 0.95, alpha: 1.0)
        }
        let restore = SKAction.run { [weak self] in
            self?.playButton.fillColor = SKColor(red: 0.15, green: 0.45, blue: 0.85, alpha: 1.0)
        }
        
        playButton.run(SKAction.sequence([flash, scaleDown, scaleUp, restore])) { [weak self] in
            self?.menuDelegate?.didTapPlay()
        }
    }
}
