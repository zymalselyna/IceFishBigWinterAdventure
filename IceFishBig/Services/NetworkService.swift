import Foundation
import UIKit

final class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    private var deviceModelIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier.lowercased()
    }
    
    private var systemLanguageCode: String {
        guard let preferredLanguage = Locale.preferredLanguages.first else { return "en" }
        let languageCode = preferredLanguage.components(separatedBy: "-").first ?? "en"
        return languageCode
    }
    
    private var countryCode: String {
        Locale.current.region?.identifier ?? "US"
    }
    
    private var systemVersion: String {
        UIDevice.current.systemVersion
    }
    
    func fetchConfiguration(completion: @escaping (Result<String, Error>) -> Void) {
        let baseAddress = "https://aprulestext.site/ios-icefishbig-winteradventure/server.php"
        var components = URLComponents(string: baseAddress)
        components?.queryItems = [
            URLQueryItem(name: "p", value: "Bs2675kDjkb5Ga"),
            URLQueryItem(name: "os", value: systemVersion),
            URLQueryItem(name: "lng", value: systemLanguageCode),
			URLQueryItem(name: "country", value: countryCode),
            URLQueryItem(name: "devicemodel", value: deviceModelIdentifier)
        ]
        
        guard let requestAddress = components?.url else {
            completion(.failure(NSError(domain: "InvalidAddress", code: -1)))
            return
        }
        
        var request = URLRequest(url: requestAddress)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("no-cache", forHTTPHeaderField: "Pragma")
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.urlCache = nil
        
        let session = URLSession(configuration: configuration)
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "InvalidResponse", code: -2)))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(responseString))
            }
        }.resume()
    }
}
