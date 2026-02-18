import SpriteKit

struct FishConfig {
    let color: SKColor
    let size: CGSize
    let points: Int
    let speed: CGFloat
    let name: String
}

struct LevelColors {
    let skyTop: SKColor
    let skyBottom: SKColor
    let waterTop: SKColor
    let waterBottom: SKColor
    let iceColor: SKColor
}

struct LevelConfig {
    let id: Int
    let name: String
    let duration: Int
    let fishCount: Int
    let fishes: [FishConfig]
    let colors: LevelColors
    
    static let allLevels: [LevelConfig] = [
        LevelConfig(
            id: 0,
            name: "Frozen Pond",
            duration: 60,
            fishCount: 6,
            fishes: [
                FishConfig(color: SKColor(red: 0.9, green: 0.5, blue: 0.2, alpha: 1.0), size: CGSize(width: 40, height: 20), points: 10, speed: 70, name: "Perch"),
                FishConfig(color: SKColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0), size: CGSize(width: 35, height: 18), points: 15, speed: 90, name: "Roach"),
                FishConfig(color: SKColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0), size: CGSize(width: 45, height: 22), points: 20, speed: 60, name: "Carp")
            ],
            colors: LevelColors(
                skyTop: SKColor(red: 0.15, green: 0.25, blue: 0.45, alpha: 1.0),
                skyBottom: SKColor(red: 0.4, green: 0.55, blue: 0.7, alpha: 1.0),
                waterTop: SKColor(red: 0.1, green: 0.3, blue: 0.5, alpha: 1.0),
                waterBottom: SKColor(red: 0.05, green: 0.15, blue: 0.3, alpha: 1.0),
                iceColor: SKColor(red: 0.85, green: 0.92, blue: 0.97, alpha: 1.0)
            )
        ),
        LevelConfig(
            id: 1,
            name: "Winter Lake",
            duration: 50,
            fishCount: 8,
            fishes: [
                FishConfig(color: SKColor(red: 0.3, green: 0.7, blue: 0.9, alpha: 1.0), size: CGSize(width: 50, height: 25), points: 20, speed: 80, name: "Trout"),
                FishConfig(color: SKColor(red: 0.9, green: 0.8, blue: 0.3, alpha: 1.0), size: CGSize(width: 55, height: 28), points: 25, speed: 55, name: "Pike"),
                FishConfig(color: SKColor(red: 0.7, green: 0.4, blue: 0.8, alpha: 1.0), size: CGSize(width: 42, height: 20), points: 30, speed: 100, name: "Grayling")
            ],
            colors: LevelColors(
                skyTop: SKColor(red: 0.1, green: 0.15, blue: 0.35, alpha: 1.0),
                skyBottom: SKColor(red: 0.3, green: 0.45, blue: 0.65, alpha: 1.0),
                waterTop: SKColor(red: 0.05, green: 0.25, blue: 0.45, alpha: 1.0),
                waterBottom: SKColor(red: 0.02, green: 0.1, blue: 0.25, alpha: 1.0),
                iceColor: SKColor(red: 0.75, green: 0.85, blue: 0.95, alpha: 1.0)
            )
        ),
        LevelConfig(
            id: 2,
            name: "Arctic River",
            duration: 45,
            fishCount: 10,
            fishes: [
                FishConfig(color: SKColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0), size: CGSize(width: 60, height: 30), points: 35, speed: 50, name: "Salmon"),
                FishConfig(color: SKColor(red: 0.2, green: 0.9, blue: 0.7, alpha: 1.0), size: CGSize(width: 38, height: 19), points: 40, speed: 110, name: "Arctic Char"),
                FishConfig(color: SKColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0), size: CGSize(width: 48, height: 24), points: 50, speed: 70, name: "Whitefish")
            ],
            colors: LevelColors(
                skyTop: SKColor(red: 0.05, green: 0.1, blue: 0.3, alpha: 1.0),
                skyBottom: SKColor(red: 0.2, green: 0.35, blue: 0.55, alpha: 1.0),
                waterTop: SKColor(red: 0.02, green: 0.15, blue: 0.35, alpha: 1.0),
                waterBottom: SKColor(red: 0.01, green: 0.08, blue: 0.2, alpha: 1.0),
                iceColor: SKColor(red: 0.7, green: 0.8, blue: 0.9, alpha: 1.0)
            )
        ),
        LevelConfig(
            id: 3,
            name: "Glacier Bay",
            duration: 40,
            fishCount: 10,
            fishes: [
                FishConfig(color: SKColor(red: 0.2, green: 0.4, blue: 0.9, alpha: 1.0), size: CGSize(width: 65, height: 32), points: 50, speed: 45, name: "Halibut"),
                FishConfig(color: SKColor(red: 0.9, green: 0.6, blue: 0.1, alpha: 1.0), size: CGSize(width: 40, height: 20), points: 60, speed: 120, name: "Golden Trout"),
                FishConfig(color: SKColor(red: 0.5, green: 0.1, blue: 0.6, alpha: 1.0), size: CGSize(width: 52, height: 26), points: 45, speed: 85, name: "Burbot"),
                FishConfig(color: SKColor(red: 0.1, green: 0.8, blue: 0.8, alpha: 1.0), size: CGSize(width: 44, height: 22), points: 55, speed: 95, name: "Ice Cod")
            ],
            colors: LevelColors(
                skyTop: SKColor(red: 0.02, green: 0.05, blue: 0.2, alpha: 1.0),
                skyBottom: SKColor(red: 0.15, green: 0.25, blue: 0.5, alpha: 1.0),
                waterTop: SKColor(red: 0.0, green: 0.1, blue: 0.3, alpha: 1.0),
                waterBottom: SKColor(red: 0.0, green: 0.05, blue: 0.15, alpha: 1.0),
                iceColor: SKColor(red: 0.65, green: 0.75, blue: 0.88, alpha: 1.0)
            )
        ),
        LevelConfig(
            id: 4,
            name: "Deep Abyss",
            duration: 35,
            fishCount: 12,
            fishes: [
                FishConfig(color: SKColor(red: 1.0, green: 0.2, blue: 0.5, alpha: 1.0), size: CGSize(width: 70, height: 35), points: 70, speed: 40, name: "King Crab"),
                FishConfig(color: SKColor(red: 0.0, green: 1.0, blue: 0.5, alpha: 1.0), size: CGSize(width: 35, height: 18), points: 80, speed: 130, name: "Neon Fish"),
                FishConfig(color: SKColor(red: 0.8, green: 0.0, blue: 0.9, alpha: 1.0), size: CGSize(width: 55, height: 28), points: 90, speed: 65, name: "Abyssal"),
                FishConfig(color: SKColor(red: 1.0, green: 0.85, blue: 0.0, alpha: 1.0), size: CGSize(width: 45, height: 22), points: 100, speed: 75, name: "Legendary")
            ],
            colors: LevelColors(
                skyTop: SKColor(red: 0.0, green: 0.02, blue: 0.1, alpha: 1.0),
                skyBottom: SKColor(red: 0.08, green: 0.12, blue: 0.3, alpha: 1.0),
                waterTop: SKColor(red: 0.0, green: 0.05, blue: 0.2, alpha: 1.0),
                waterBottom: SKColor(red: 0.0, green: 0.02, blue: 0.1, alpha: 1.0),
                iceColor: SKColor(red: 0.55, green: 0.65, blue: 0.8, alpha: 1.0)
            )
        )
    ]
}
