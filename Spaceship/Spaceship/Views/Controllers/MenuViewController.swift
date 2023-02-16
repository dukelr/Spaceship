
import UIKit

class MenuViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var spaceshipView: UIView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highscoreView: UIView!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var settingLabel: UILabel!
    
    //MARK: - var/let
    
    private var user = User.getDefaultUser()
    
    //MARK: - lifecycle funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
    }
    
    //MARK: - IBActions
    
    @IBAction func highscoreButtonPressed(_ sender: UIButton) {
        showHighscoreController()
        changeAlphaView(highscoreView)
    }
    
    @IBAction func highscoreButtonTouched(_ sender: UIButton) {
        changeAlphaView(highscoreView)
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        startGame()
        changeAlphaView(startView)
    }
    
    @IBAction func startButtonTouched(_ sender: UIButton) {
        changeAlphaView(startView)
    }
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        showSettingController()
        changeAlphaView(settingView)
    }
    
    @IBAction func settingButtonTouched(_ sender: UIButton) {
        changeAlphaView(settingView)
    }
    
    //MARK: - flow funcs
    
    private func showHighscoreController() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: HighscoreViewController.identifier) as? HighscoreViewController else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showSettingController() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: SettingsViewController.identifier) as? SettingsViewController else { return }
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func startGame() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: GameViewController.identifier) as? GameViewController else { return }
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func changeAlphaView(_ view: UIView) {
        let duration = 0.1
        if view.alpha == 1 {
            UIView.animate(withDuration: duration) {
                view.alpha = 0.1
            }
        } else {
            UIView.animate(withDuration: duration) {
                view.alpha = 1
            }
        }
    }
    
    private func configureSubviews() {
        if let user = StorageManager.shared.loadUser() {
            self.user = user
        }
        nicknameLabel.text = user.nickname
        coinsLabel.text = "\(user.coins)"
        scoreLabel.text = "\(user.record)"
        highscoreLabel.text = LocalizationKey.highscore.rawValue.localized()
        startLabel.text = LocalizationKey.start.rawValue.localized()
        settingLabel.text = LocalizationKey.settings.rawValue.localized()
        spaceshipView.bordered()
        spaceshipView.rounded()
        spaceshipView.setBorderColor(.lightGray)
    }
}

//MARK: - Extensions

extension MenuViewController: SettingsViewControllerDelegate {
    
    func settingsViewControllerClosed() {
        if let user = StorageManager.shared.loadUser() {
            self.user = user
        }
        nicknameLabel.text = user.nickname
        coinsLabel.text = "\(user.coins)"
    }
}

extension MenuViewController: GameViewControllerDelegate {
    
    func gameViewControllerClosed() {
        if let user = StorageManager.shared.loadUser() {
            self.user = user
        }
        scoreLabel.text = "\(user.record)"
        coinsLabel.text = "\(user.coins)"
    }
}

