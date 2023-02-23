
import Foundation
import AVFoundation

private extension String {
    static let soundType = "mp3"
}

final class SoundManager {
    
    static let shared = SoundManager()
    
    private var otherSoundAudioPlayer: AVAudioPlayer?
    private var spaceshipAudioPlayer: AVAudioPlayer?
        
    func playSound(_ soundName: SoundName) {
        guard let fileName = Bundle.main.path(forResource: soundName.rawValue, ofType: .soundType) else { return }
        
        let url = URL(fileURLWithPath: fileName)
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        if soundName == .spaceship {
            playSpaceshipSound(with: url)
            return
        }
        otherSoundAudioPlayer = try? AVAudioPlayer(contentsOf: url)
        otherSoundAudioPlayer?.volume = 1
        otherSoundAudioPlayer?.prepareToPlay()
        otherSoundAudioPlayer?.play()
        
    }
    
    private func playSpaceshipSound(with url: URL) {
        spaceshipAudioPlayer = try? AVAudioPlayer(contentsOf: url)
        spaceshipAudioPlayer?.numberOfLoops = -1
        spaceshipAudioPlayer?.volume = 1
        spaceshipAudioPlayer?.prepareToPlay()
        spaceshipAudioPlayer?.play()
    }
    
    func stopSound() {
        spaceshipAudioPlayer?.stop()
        otherSoundAudioPlayer?.stop()
    }
}
