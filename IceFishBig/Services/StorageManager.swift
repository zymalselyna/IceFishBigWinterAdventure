import Foundation

final class StorageManager {
    static let shared = StorageManager()
    
    private let tokenKey = "savedAccessToken"
    private let linkKey = "savedRemoteLink"
    
    private init() {}
    
    var accessToken: String? {
        get { UserDefaults.standard.string(forKey: tokenKey) }
        set { UserDefaults.standard.set(newValue, forKey: tokenKey) }
    }
    
    var remoteLink: String? {
        get { UserDefaults.standard.string(forKey: linkKey) }
        set { UserDefaults.standard.set(newValue, forKey: linkKey) }
    }
    
    var hasStoredToken: Bool {
        guard let token = accessToken, !token.isEmpty else { return false }
        return true
    }
    
    func clearAll() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: linkKey)
    }
}
