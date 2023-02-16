
import Foundation

class Setting: Codable {
    
    var control: String
    var speed: String
    var spaceship: String
    var laser: String
//    var sound: Bool
    
    init(control: String, speed: String, spaceship: String, laser: String) {
        self.control = control
        self.speed = speed
        self.spaceship = spaceship
        self.laser = laser
    }
    
    static func getDefaultSettings() -> Setting {
        Setting(control: "hand.tap", speed: "tortoise", spaceship: "spaceship_white", laser: "laser_white")
    }
}
