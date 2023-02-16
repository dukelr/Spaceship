
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

//MARK: - Protocols

protocol SettingsViewControllerDelegate: AnyObject {
    func settingsViewControllerClosed()
}

class SettingsViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var soundLabel: UILabel!
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
        backToMenuController()
    }
    
    @IBAction func controlButtonPressed(_ sender: UIButton) {
        changeControl()
    }
    
    @IBAction func speedButtonPressed(_ sender: UIButton) {
        changeSpeed()
    }
    
    @IBAction func colorButtonPressed(_ sender: UIButton) {
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
        nicknameLabel.text = LocalizationKey.nickname.rawValue.localized()
        speedLabel.text = LocalizationKey.speed.rawValue.localized()
        colorLabel.text = LocalizationKey.color.rawValue.localized()
        soundLabel.text = LocalizationKey.sound.rawValue.localized()
        controlLabel.text = LocalizationKey.control.rawValue.localized()
        warningLabel.text = LocalizationKey.warning.rawValue.localized()
        spaceshipImageView.image = UIImage(named: user.settings.spaceship)
        laserImageView.image = UIImage(named: user.settings.laser)
        
        if user.settings.speed == Speed.fast.rawValue {
            speed = .fast
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
        let setting = Setting(
            control: control.rawValue,
            speed: speed.rawValue,
            spaceship: spaceshipImageNamesArray[index],
            laser: laserImageNamesArray[index])
        user.nickname = nickname
        user.settings = setting
        StorageManager.shared.saveUser(user)
    }
    
    private func changeControl() {
        if control == .gyroscope {
            control = .buttons
        } else {
            control = .gyroscope
        }
        controlButton.setBackgroundImage(UIImage(systemName: control.rawValue), for: .normal)
        saveSetting()
    }
    
    private func changeSpeed() {
        let offset = CGFloat(3)
        if speed == .fast {
            speed = .slow
            speedButtonHeigthConstraint.constant -= offset
        } else {
            speed = .fast
            speedButtonHeigthConstraint.constant += offset
        }
        speedButton.setBackgroundImage(UIImage(systemName: speed.rawValue), for: .normal)
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
                self?.spaceshipView.alpha = 0.1
            }
        } else {
            UIView.animate(withDuration: duration) { [weak self] in
                self?.spaceshipView.alpha = 1
            }
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
