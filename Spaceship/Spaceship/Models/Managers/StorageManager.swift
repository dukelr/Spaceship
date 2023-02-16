
import Foundation
import UIKit

private extension String {
    static let userKey = "user"
    static let resultsKey = "results"
}

class StorageManager {
    
    static let shared = StorageManager()
    
    private init() {}
    
    func saveUser(_ user: User) {
        UserDefaults.standard.set(encodable: user, forKey: .userKey)
    }
    
    func loadUser() -> User? {
        UserDefaults.standard.value(User.self, forKey: .userKey)
    }
    
    func saveResults(_ results: [Result]) {
        UserDefaults.standard.set(encodable: results, forKey: .resultsKey)
    }
    
    func loadResults() -> [Result]? {
        UserDefaults.standard.value([Result].self, forKey: .resultsKey)
    }
}
