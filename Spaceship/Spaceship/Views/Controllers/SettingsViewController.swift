
import UIKit

//MARK: - Enums

private enum Speed: String {
    case fast = "hare"
    case slow = "tortoise"
}

private enum Control: String {
    case buttons = "hand.tap"
    case gyroscope
}

private enum Sound: String {
    case off = "speaker.slash"
    case on = "speaker.wave.2"
}

private extension CGFloat {
    static let offset = 3.0
}

//MARK: - Protocols

protocol SettingsViewControllerDelegate: AnyObject {
    func settingsViewControllerClosed()
}

final class SettingsViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var soundButtonWidthCoinstraint: NSLayoutConstraint!
    @IBOutlet weak var controlLabel: UILabel!
    @IBOutlet weak var controlButton: UIButton!
    @IBOutlet weak var controlButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedButton: UIButton!
    @IBOutlet weak var speedButtonHeigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var spaceshipView: UIView!
    @IBOutlet weak var spaceshipImageView: UIImageView!
    @IBOutlet weak var laserImageView: UIImageView!
    
    //MARK: - let/var
    
    static let identifier = "SettingsViewController"
    weak var delegate: SettingsViewControllerDelegate?
    private var sound = true
    private var speed = Speed.slow
    private var control = Control.buttons
    private var user = User.getDefaultUser()
    private var index = Int()
    private let spaceshipImageNamesArray = [
        "spaceship_white",
        "spaceship_red",
        "spaceship_green",
        "spaceship_blue",
        "spaceship_orange",
        "spaceship_yellow",
        "spaceship_purple"
    ]
    private let laserImageNamesArray = [
        "laser_white",
        "laser_red",
        "laser_green",
        "laser_blue",
        "laser_orange",
        "laser_yellow",
        "laser_purple"
    ]
    
    //MARK: - lifecycle funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    //MARK: - IBActions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        playSoundButton()
        backToMenuController()
    }
    
    @IBAction func soundButtonPressed(_ sender: UIButton) {
        playSoundButton()
        changeSound()
    }
    
    @IBAction func controlButtonPressed(_ sender: UIButton) {
        playSoundButton()
        changeControl()
    }
    
    @IBAction func speedButtonPressed(_ sender: UIButton) {
        playSoundButton()
        changeSpeed()
    }
    
    @IBAction func colorButtonPressed(_ sender: UIButton) {
        playSoundButton()
        changeColor()
        changeAlphaSpaceship()
    }
    
    @IBAction func colorButtonTouched(_ sender: UIButton) {
        changeAlphaSpaceship()
    }
    
    //MARK: - flow funcs
    
    private func configureSubviews() {
        if let user = StorageManager.shared.loadUser() {
            self.user = user
        }
        nicknameTextField.text = user.nickname
        nicknameLabel.text = .localized(.nickname)
        speedLabel.text = .localized(.speed)
        colorLabel.text = .localized(.color)
        soundLabel.text = .localized(.sound)
        controlLabel.text = .localized(.control)
        warningLabel.text = .localized(.warning)
        spaceshipImageView.image = UIImage(named: user.settings.spaceship)
        laserImageView.image = UIImage(named: user.settings.laser)
        
        if user.settings.sound {
            sound = true
            soundButton.setBackgroundImage(
                UIImage(systemName: Sound.on.rawValue),
                for: .normal
            )
        } else {
            sound = false
            soundButton.setBackgroundImage(
                UIImage(systemName: Sound.off.rawValue),
                for: .normal
            )
            soundButtonWidthCoinstraint.constant -= .offset * 2.5
        }
        if user.settings.speed == Speed.fast.rawValue {
            speed = .fast
            speedButtonHeigthConstraint.constant += .offset
        } else {
            speed = .slow
        }
        speedButton.setBackgroundImage(
            UIImage(systemName: speed.rawValue),
            for: .normal
        )
        if user.settings.control == Control.buttons.rawValue {
            control = .buttons
        } else {
            control = .gyroscope
        }
        controlButton.setBackgroundImage(
            UIImage(systemName: control.rawValue),
            for: .normal
        )
        if let index = spaceshipImageNamesArray.firstIndex(of: user.settings.spaceship) {
            self.index = index
        }
    }
    
    private func saveSetting() {
        guard let nickname = nicknameTextField.text else { return }
        
        let settings = Setting(
            control: control.rawValue,
            speed: speed.rawValue,
            spaceship: spaceshipImageNamesArray[index],
            laser: laserImageNamesArray[index],
            sound: sound
        )
        user.nickname = nickname
        user.settings = settings
        StorageManager.shared.saveUser(user)
    }
    
    private func changeSound() {
        if sound {
            soundButtonWidthCoinstraint.constant -= .offset * 2.5
            soundButton.setBackgroundImage(
                UIImage(systemName: Sound.off.rawValue),
                for: .normal
            )
        } else {
            soundButtonWidthCoinstraint.constant += .offset * 2.5
            soundButton.setBackgroundImage(
                UIImage(systemName: Sound.on.rawValue),
                for: .normal
            )
        }
        sound.toggle()
        saveSetting()
    }
    
    private func changeControl() {
        if control == .gyroscope {
            control = .buttons
        } else {
            control = .gyroscope
        }
        controlButton.setBackgroundImage(
            UIImage(systemName: control.rawValue),
            for: .normal
        )
        saveSetting()
    }
    
    private func changeSpeed() {
        if speed == .fast {
            speed = .slow
            speedButtonHeigthConstraint.constant -= .offset
        } else {
            speed = .fast
            speedButtonHeigthConstraint.constant += .offset
        }
        speedButton.setBackgroundImage(
            UIImage(systemName: speed.rawValue),
            for: .normal
        )
        saveSetting()
    }
    
    private func changeColor() {
        if index < spaceshipImageNamesArray.count - 1 {
            index += 1
        } else {
            index = 0
        }
        spaceshipImageView.image = UIImage(named: spaceshipImageNamesArray[index])
        laserImageView.image = UIImage(named: laserImageNamesArray[index])
        saveSetting()
    }
    
    private func changeAlphaSpaceship() {
        let duration = 0.05
        if spaceshipView.alpha == 1 {
            UIView.animate(withDuration: duration) { [weak self] in
                guard let self = self else { return }
                
                self.spaceshipView.alpha = 0.1
            }
        } else {
            UIView.animate(withDuration: duration) { [weak self] in
                guard let self = self else { return }

                self.spaceshipView.alpha = 1
            }
        }
    }
    
    private func playSoundButton() {
        if sound {
            SoundManager.shared.playSound(.button)
        }
    }

    private func backToMenuController() {
        if !warningLabel.isHidden { return }
        
        delegate?.settingsViewControllerClosed()
        navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - Extensions

extension SettingsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
              let rangeOfTextToReplace = Range(range, in: text) else { return false }
        
        let substringToReplace = text[rangeOfTextToReplace]
        let count = text.count - substringToReplace.count + string.count
        let filtered = string.replacingOccurrences(of: " ", with: "")
        return string == filtered && count <= 10
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if text.count < 3 {
            warningLabel.isHidden = false
        } else {
            warningLabel.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveSetting()
        textField.resignFirstResponder()
        return true
    }
}
