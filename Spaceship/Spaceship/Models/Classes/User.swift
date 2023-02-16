
import Foundation

class User: Codable {
    
    var nickname: String
    var coins: Int
    var record: Int
    var settings: Setting
    
    init(nickname: String, coins: Int, record: Int, settings: Setting) {
        self.nickname = nickname
        self.coins = coins
        self.record = record
        self.settings = settings
    }
    
    static func getDefaultUser() -> User {
        User(nickname: "Spaceman", coins: 0, record: 0, settings: Setting.getDefaultSettings())
    }
}
