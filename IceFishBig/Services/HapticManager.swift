import UIKit

final class HapticManager {
    static let shared = HapticManager()
    
    private let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    private let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()
    
    private init() {
        lightGenerator.prepare()
        mediumGenerator.prepare()
        heavyGenerator.prepare()
        notificationGenerator.prepare()
        selectionGenerator.prepare()
    }
    
    private var isEnabled: Bool {
        UserDefaults.standard.bool(forKey: "vibrationEnabled")
    }
    
    func fishCaught() {
        guard isEnabled else { return }
        heavyGenerator.impactOccurred()
    }
    
    func hookDropped() {
        guard isEnabled else { return }
        lightGenerator.impactOccurred()
    }
    
    func gameOver() {
        guard isEnabled else { return }
        notificationGenerator.notificationOccurred(.warning)
    }
    
    func buttonTap() {
        guard isEnabled else { return }
        selectionGenerator.selectionChanged()
    }
    
    func levelComplete() {
        guard isEnabled else { return }
        notificationGenerator.notificationOccurred(.success)
    }
    
    func timerWarning() {
        guard isEnabled else { return }
        mediumGenerator.impactOccurred()
    }
}
