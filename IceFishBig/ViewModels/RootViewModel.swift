import Foundation

enum LaunchDestination {
    case remoteContent(link: String)
    case gameTabBar
}

final class RootViewModel {
    private let storage = StorageManager.shared
    private let network = NetworkService.shared
    
    private(set) var wasTokenPreloaded: Bool = false
    
    func checkInitialState(completion: @escaping (LaunchDestination) -> Void) {
        if storage.hasStoredToken, let link = storage.remoteLink {
            wasTokenPreloaded = true
            completion(.remoteContent(link: link))
            return
        }
        
        network.fetchConfiguration { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if response.contains("#") {
                    let parts = response.components(separatedBy: "#")
                    if parts.count >= 2 {
                        let token = parts[0]
                        let link = parts[1]
                        self.storage.accessToken = token
                        self.storage.remoteLink = link
                        self.wasTokenPreloaded = false
                        completion(.remoteContent(link: link))
                        return
                    }
                }
                completion(.gameTabBar)
                
            case .failure:
                completion(.gameTabBar)
            }
        }
    }
}
