
import Foundation
import AVFoundation

private extension String {
    static let soundType = "mp3"
}

final class SoundManager {
    
    static let shared = SoundManager()
    
    private var player: AVAudioPlayer?
    
    enum SoundName: String {
        case spaceship = "sound_spaceship"
        case laser = "sound_laser"
        case button = "sound_button"
    }
    
    func playSound(_ soundName: SoundName, repeats: Bool = false) {
        guard let fileName = Bundle.main.path(forResource: soundName.rawValue, ofType: .soundType) else { return }
        
        let url = URL(fileURLWithPath: fileName)
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        player = try? AVAudioPlayer(contentsOf: url)
        player?.volume = 1
        player?.prepareToPlay()
        player?.play()
        
        if repeats {
            player?.numberOfLoops = -1
        }
    }
    
    func stopSound() {
//        players?.forEach { player in
            player?.stop()
//        }
    }
}
