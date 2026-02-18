import Foundation

struct LevelStats: Codable {
    var gamesPlayed: Int = 0
    var highScore: Int = 0
    var totalFishCaught: Int = 0
    var bestTime: Int = 0
}

extension Notification.Name {
    static let statsDidUpdate = Notification.Name("statsDidUpdate")
}

final class GameViewModel {
    private let statsKey = "levelStatsData"
    
    private(set) var allStats: [Int: LevelStats] = [:]
    
    init() {
        loadStats()
    }
    
    func reloadFromDisk() {
        loadStats()
    }
    
    func statsForLevel(_ levelId: Int) -> LevelStats {
        return allStats[levelId] ?? LevelStats()
    }
    
    func saveGameResult(levelId: Int, score: Int, fishCaught: Int, timeUsed: Int) {
        var stats = statsForLevel(levelId)
        stats.gamesPlayed += 1
        stats.totalFishCaught += fishCaught
        if score > stats.highScore {
            stats.highScore = score
        }
        if timeUsed > stats.bestTime {
            stats.bestTime = timeUsed
        }
        allStats[levelId] = stats
        saveStats()
    }
    
    var overallHighScore: Int {
        allStats.values.map { $0.highScore }.max() ?? 0
    }
    
    var totalGamesPlayed: Int {
        allStats.values.map { $0.gamesPlayed }.reduce(0, +)
    }
    
    var totalFishCaught: Int {
        allStats.values.map { $0.totalFishCaught }.reduce(0, +)
    }
    
    func resetAllStats() {
        allStats.removeAll()
        saveStats()
    }
    
    private func loadStats() {
        guard let data = UserDefaults.standard.data(forKey: statsKey),
              let decoded = try? JSONDecoder().decode([Int: LevelStats].self, from: data) else { return }
        allStats = decoded
    }
    
    private func saveStats() {
        guard let data = try? JSONEncoder().encode(allStats) else { return }
        UserDefaults.standard.set(data, forKey: statsKey)
        NotificationCenter.default.post(name: .statsDidUpdate, object: nil)
    }
}
