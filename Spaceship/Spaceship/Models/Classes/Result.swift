
import Foundation

final class Result: Codable {
    
    var nickname: String
    var score: Int
    var speed: String
    var date: String
    
    init(nickname: String, score: Int, speed: String, date: String) {
        self.nickname = nickname
        self.score = score
        self.speed = speed
        self.date = date
    }
}
