
import UIKit
import CoreMotion

//MARK: - Enums

private enum Direction {
    case left
    case right
    case up
    case down
}

private enum Item: CaseIterable {
    case shield
    case laser
    case heart
    case coin
    case star
}

private enum Speed: TimeInterval {
    case fast = 1
    case slow = 1.5
}

private enum Control: String {
    case buttons
    case gyroscope
}

private enum AnimationPhase {
    case small
    case medium
    case normal
    case retrieval
}

//MARK: - private extensions

private extension UIImage {
    static let spaceImage = UIImage(named: "space")
    static let backImage = UIImage(systemName: "rectangle.portrait.and.arrow.right")
    static let leftImage = UIImage(systemName: "chevron.left")
    static let rightImage = UIImage(systemName: "chevron.right")
    static let shootImage = UIImage(systemName: "target")
    static let jumpImage = UIImage(systemName: "wake.circle")
    static let coinImage = UIImage(systemName: "circle")
    static let scoreImage = UIImage(systemName: "star")
    static let lifeImage = UIImage(systemName: "heart")
}

private extension TimeInterval {
    static let second = 1.0
    static let standartForAnimate = 0.3
    static let standartForRepeatTimer = 0.1
}

private extension String {
    static let one = "1"
    static let two = "2"
    static let three = "3"
    static let fast = "hare"
    static let dateFormat = "dd.MM.yyyy"
}

protocol GameViewControllerDelegate: AnyObject {
    func gameViewControllerClosed()
}

final class GameViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var gameOverView: UIView!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var yourScoreLabel: UILabel!
    @IBOutlet weak var repeatButton: UIButton!
    
    //MARK: - var/let
    
    static let identifier = "GameViewController"
    weak var delegate: GameViewControllerDelegate?
    private let motionManager = CMMotionManager()
    private let spaceView = UIView()
    private let topSpaceImageView = UIImageView()
    private let bottomSpaceImageView = UIImageView()
    private let startGameLabel = UILabel()
    private let leftEdgeView = UIView()
    private let rightEdgeView = UIView()
    private let topContainerView = UIView()
    private let scoreLabel = UILabel()
    private let coinsLabel = UILabel()
    private let backButton = UIButton()
    private let bottomContainerView = UIView()
    private let rightButton = UIButton()
    private let spaceshipImageView = UIImageView()
    private var normalSizeForSpaceship = CGSize()
    private let laserImageView = UIImageView()
    private let shieldImageView = UIImageView()
    private let fireImageView = UIImageView()
    private let lifeView = UIView()
    private var life = Bool()
    private var lifeTimer = Timer()
    private var fullLifeWidth = CGFloat()
    private var score = Int()
    private var scoreBoost = Int()
    private var scoreBonus = Int()
    private var coins = Int()
    private var intersectionCheck = true
    private var sound = Bool()
    private var speed = Speed.fast.rawValue
    private var control = Control.buttons
    private var user = StorageManager.shared.loadUser() ?? User.getDefaultUser()
    private var itemImageViewsArray = [UIImageView]()
    private var meteoriteImageViewsArray = [UIImageView]()
    private let firstMeteoriteImagesArray = [
        UIImage(named: "meteorite_0"),
        UIImage(named: "meteorite_1"),
        UIImage(named: "meteorite_2"),
        UIImage(named: "meteorite_3"),
        UIImage(named: "meteorite_4"),
        UIImage(named: "meteorite_5"),
        UIImage(named: "meteorite_6"),
        UIImage(named: "meteorite_7"),
        UIImage(named: "meteorite_8"),
        UIImage(named: "meteorite_9"),
        UIImage(named: "meteorite_10"),
        UIImage(named: "meteorite_11"),
        UIImage(named: "meteorite_12"),
        UIImage(named: "meteorite_13"),
        UIImage(named: "meteorite_14"),
        UIImage(named: "meteorite_15"),
        UIImage(named: "meteorite_16"),
        UIImage(named: "meteorite_17"),
        UIImage(named: "meteorite_18"),
        UIImage(named: "meteorite_19"),
        UIImage(named: "meteorite_20"),
        UIImage(named: "meteorite_21"),
        UIImage(named: "meteorite_22"),
        UIImage(named: "meteorite_23"),
        UIImage(named: "meteorite_24"),
        UIImage(named: "meteorite_25"),
        UIImage(named: "meteorite_26"),
        UIImage(named: "meteorite_27"),
        UIImage(named: "meteorite_28"),
        UIImage(named: "meteorite_29"),
        UIImage(named: "meteorite_30"),
    ]
    private let secondMeteoriteImagesArray = [
        UIImage(named: "meteorite_31"),
        UIImage(named: "meteorite_32"),
        UIImage(named: "meteorite_33"),
        UIImage(named: "meteorite_34"),
        UIImage(named: "meteorite_35"),
        UIImage(named: "meteorite_36"),
        UIImage(named: "meteorite_37"),
        UIImage(named: "meteorite_38"),
        UIImage(named: "meteorite_39"),
        UIImage(named: "meteorite_40"),
        UIImage(named: "meteorite_41"),
        UIImage(named: "meteorite_42"),
        UIImage(named: "meteorite_43"),
        UIImage(named: "meteorite_44"),
        UIImage(named: "meteorite_45"),
        UIImage(named: "meteorite_46"),
        UIImage(named: "meteorite_47"),
        UIImage(named: "meteorite_48"),
        UIImage(named: "meteorite_49"),
        UIImage(named: "meteorite_50"),
        UIImage(named: "meteorite_51"),
        UIImage(named: "meteorite_52"),
        UIImage(named: "meteorite_53"),
        UIImage(named: "meteorite_54"),
        UIImage(named: "meteorite_55"),
        UIImage(named: "meteorite_56"),
        UIImage(named: "meteorite_57"),
        UIImage(named: "meteorite_58"),
        UIImage(named: "meteorite_59"),
        UIImage(named: "meteorite_60"),
        UIImage(named: "meteorite_61")
    ]
    private let shieldImagesArray = [
        UIImage(named: "shield_0"),
        UIImage(named: "shield_1"),
        UIImage(named: "shield_2"),
        UIImage(named: "shield_3")
    ]
    private let coinImagesArray = [
        UIImage(named: "coin_0"),
        UIImage(named: "coin_1"),
        UIImage(named: "coin_2"),
        UIImage(named: "coin_3"),
        UIImage(named: "coin_4"),
        UIImage(named: "coin_5"),
        UIImage(named: "coin_6"),
        UIImage(named: "coin_7"),
        UIImage(named: "coin_8")
        
    ]
    private let heartImagesArray = [
        UIImage(named: "heart_0"),
        UIImage(named: "heart_1"),
        UIImage(named: "heart_2"),
        UIImage(named: "heart_3"),
        UIImage(named: "heart_4"),
        UIImage(named: "heart_5"),
        UIImage(named: "heart_6"),
        UIImage(named: "heart_7")
    ]
    private let starImagesArray = [
        UIImage(named: "star_0"),
        UIImage(named: "star_1"),
        UIImage(named: "star_2"),
        UIImage(named: "star_3"),
        UIImage(named: "star_4"),
        UIImage(named: "star_5"),
        UIImage(named: "star_6")
    ]
    private let fireImagesArray = [
        UIImage(named: "fire_0"),
        UIImage(named: "fire_1"),
        UIImage(named: "fire_2"),
        UIImage(named: "fire_3"),
        UIImage(named: "fire_4"),
        UIImage(named: "fire_5")
    ]
    
    //MARK: - lifecycle funcs
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSubviews()
    }
    
    //MARK: - IBActions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        backToMenuController()
    }
    
    @IBAction func repeatButtonPressed(_ sender: UIButton) {
        setupSubviews()
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        animateSpaseshipWithButtons(.left)
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        animateSpaseshipWithButtons(.right)
    }
    
    @IBAction func jumpButtonPressed(_ sender: UIButton) {
        animateSpaseshipWithButtons(.up)
    }
    
    @IBAction func shootButtonPressed(_ sender: UIButton) {
        shootLaser()
    }
    
    @IBAction func tapDetected(_ sender: UITapGestureRecognizer) {
        shootLaser()
    }
    
    //MARK: - flow funcs
    
    private func setupSubviews() {
        yourScoreLabel.text = .localized(.score)
        gameOverLabel.bordered()
        gameOverLabel.rounded()
        gameOverLabel.setBorderColor(gameOverLabel.textColor)
        checkSetting()
        addSpace()
        addEdgeViews()
        addContainerViews()
        addScoreLabel()
        addBackButton()
        addLifeView()
        addCoinsLabel()
        addDirectionButtons()
        addShootButton()
        addJumpButton()
        addTapRecognizer()
        addSpaceship()
        addFire()
        addShield()
        addLaser()
        addStartGameLabel()
        readyStartGame()
    }
    
    private func checkSetting() {
        if user.settings.sound {
            sound = true
        } else {
            sound = false
        }
        if user.settings.speed == .fast {
            speed = Speed.fast.rawValue
        } else {
            speed = Speed.slow.rawValue
        }
        if user.settings.control == Control.gyroscope.rawValue {
            control = .gyroscope
        } else {
            control = .buttons
        }
        spaceshipImageView.image = UIImage(named: user.settings.spaceship)
    }
    
    private func readyStartGame() {
        life = true
        animateSpace()
        animateShieldAndFire()
        startGameLabel.isHidden = false
        playSound(.spaceship)
        
        Timer.scheduledTimer(
            withTimeInterval: .second,
            repeats: true
        ) { [weak self] timer in
            guard let self = self else { return }

            switch self.startGameLabel.text {
            case String.three:
                self.startGameLabel.text = .two
                self.startGameLabel.textColor = .customYellow
            case String.two:
                self.startGameLabel.text = .one
                self.startGameLabel.textColor = .customGreen
            default:
                self.startGame()
                timer.invalidate()
            }
        }
    }
    
    private func startGame() {
        if control == .buttons {
            bottomContainerView.isHidden = false
        } else {
            bottomContainerView.removeFromSuperview()
        }
        topContainerView.isHidden = false
        startGameLabel.isHidden = true
        gameOverView.isHidden = true
        repeatButton.isHidden = true
        startLifeTimer()
        moveMeteorite()
        moveItem()
        score = 0
        coins = 0
        scoreBoost = 1
        scoreBonus = 100
    }
    
    private func startLifeTimer() {
        lifeTimer = .scheduledTimer(
            withTimeInterval: .standartForRepeatTimer,
            repeats: true
        ) { [weak self] _ in
            guard let self = self else { return }
            
            self.checkLife()
            self.moveLife()
            self.animateSpaceshipWithGyroscope()
            self.checkIntersectsLaserWithMeteorite()
            self.checkIntersectsSpaceshipWithMeteorite(self.intersectionCheck)
            self.checkIntersectsSpaceshipWithItem(self.intersectionCheck)
            self.updateResult()
        }
    }
    
    private func updateResult() {
        spaceView.insertSubview(topContainerView, at: spaceView.subviews.count - 1)
        spaceView.insertSubview(bottomContainerView, at: spaceView.subviews.count - 1)
        score += scoreBoost
        scoreLabel.text = "\(score)"
        coinsLabel.text = "\(coins)"
    }
    
    private func saveResultGame() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = .dateFormat
        let stringDate = formatter.string(from: date)
        let result = Result(
            nickname: user.nickname,
            score: score,
            speed: user.settings.speed,
            date: stringDate
        )
        let results = updateResultsArray(result)
        
        if user.record < score {
            user.record = score
        }
        user.coins += coins
        StorageManager.shared.saveUser(user)
        StorageManager.shared.saveResults(results)
    }
    
    private func updateResultsArray(_ result: Result) -> [Result] {
        var resultsArray = [Result]()
        
        if let results = StorageManager.shared.loadResults() {
            resultsArray = results
        }
        resultsArray.append(result)
        resultsArray = resultsArray.sorted(by: { $0.score > $1.score } )
        
        if resultsArray.count > .countResults {
            resultsArray.removeLast()
        }
        return resultsArray
    }
    
    private func playSound(_ soundName: SoundName) {
        if sound {
            SoundManager.shared.playSound(soundName)
        }
    }
    
    private func selectImage(_ imageView: UIImageView, in array: [UIImage?]) {
        guard var index = array.firstIndex(of: imageView.image) else { return }
        
        if index >= array.count - 1 {
            index = 0
        } else {
            index += 1
        }
        imageView.image = array[index]
    }
    
    private func backToMenuController() {
        SoundManager.shared.stopSound()
        lifeTimer.invalidate()
        spaceView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        delegate?.gameViewControllerClosed()
        navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - checks funcs
    
    private func checkLife() {
        if !life {
            lifeTimer.invalidate()
            SoundManager.shared.stopSound()
            itemImageViewsArray.forEach { item in
                item.removeFromSuperview()
            }
            meteoriteImageViewsArray.forEach { meteorite in
                meteorite.removeFromSuperview()
            }
            view.insertSubview(gameOverView, at: view.subviews.count)
            gameOverView.addSubview(backButton)
            resultLabel.text = "\(score)"
            gameOverView.isHidden = false
            bottomContainerView.isHidden = true
            topContainerView.isHidden = true
            saveResultGame()
        }
    }
    
    private func checkIntersectsLaserWithMeteorite() {
        guard let laserPresentationFrame = laserImageView.layer.presentation()?.frame else { return }
        
        meteoriteImageViewsArray.forEach { meteorite in
            if let meteoritePresentationFrame = meteorite.layer.presentation()?.frame,
               laserPresentationFrame.intersects(meteoritePresentationFrame),
               laserImageView.frame.origin.y < spaceshipImageView.frame.origin.y,
               !laserImageView.isHidden {
                score += scoreBonus * scoreBoost
                meteoriteImageViewsArray = meteoriteImageViewsArray.filter { $0 != meteorite }
                laserImageView.isHidden = true
                meteorite.removeFromSuperview()
            }
        }
    }
    
    private func checkIntersectsSpaceshipWithMeteorite(_ intersectionCheck: Bool?) {
        guard let spaceshipPresentationFrame = spaceshipImageView.layer.presentation()?.frame,
              let shieldPresentatinFrame = shieldImageView.layer.presentation()?.frame,
              let check = intersectionCheck,
              check else { return }
        
        meteoriteImageViewsArray.forEach { meteorite in
            guard let meteoritePresentationFrame = meteorite.layer.presentation()?.frame else { return }
            
            if shieldPresentatinFrame.intersects(meteoritePresentationFrame),
               !shieldImageView.isHidden {
                score += scoreBonus * scoreBoost
                shieldImageView.isHidden = true
                meteoriteImageViewsArray = meteoriteImageViewsArray.filter { $0 != meteorite }
                meteorite.removeFromSuperview()
                return
            }
            if spaceshipPresentationFrame.intersects(meteoritePresentationFrame) {
                life = false
            }
        }
    }
    
    private func checkIntersectsSpaceshipWithItem(_ intersectionCheck: Bool?) {
        guard let spaceshipPresentationFrame = spaceshipImageView.layer.presentation()?.frame,
              let check = intersectionCheck,
              check else { return }
        
        itemImageViewsArray.forEach { item in
            if let itemPresentationFrame = item.layer.presentation()?.frame,
               spaceshipPresentationFrame.intersects(itemPresentationFrame) {
                
                if shieldImagesArray.contains(item.image) {
                    shieldImageView.isHidden = false
                }
                if item.image == laserImageView.image {
                    laserImageView.isHidden = false
                }
                if heartImagesArray.contains(item.image) {
                    UIView.animate(withDuration: .standartForAnimate) { [weak self] in
                        guard let self = self else { return }
                        
                        self.lifeView.frame.size.width = self.fullLifeWidth
                    }
                }
                if coinImagesArray.contains(item.image) {
                    playSound(.coin)
                    coins += 1
                }
                if starImagesArray.contains(item.image) {
                    playSound(.star)
                    scoreBoost += 1
                }
                score += scoreBonus * scoreBoost
                itemImageViewsArray = itemImageViewsArray.filter { $0 != item }
                item.removeFromSuperview()
            }
        }
    }
    
    //MARK: - create views funcs
    
    private func addSpace() {
        spaceView.frame = view.frame
        spaceView.backgroundColor = .black
        view.addSubview(spaceView)
        
        bottomSpaceImageView.frame = spaceView.frame
        bottomSpaceImageView.image = .spaceImage
        bottomSpaceImageView.contentMode = .center
        spaceView.addSubview(bottomSpaceImageView)
        
        topSpaceImageView.frame = spaceView.frame
        topSpaceImageView.frame.origin.y = -bottomSpaceImageView.frame.height
        topSpaceImageView.image = .spaceImage
        topSpaceImageView.contentMode = .center
        spaceView.addSubview(topSpaceImageView)
    }
    
    private func addEdgeViews() {
        leftEdgeView.frame.origin = spaceView.frame.origin
        leftEdgeView.frame.size = CGSize(
            width: spaceView.frame.width / spaceView.frame.width,
            height: spaceView.frame.height)
        spaceView.addSubview(leftEdgeView)
        
        rightEdgeView.frame.size = leftEdgeView.frame.size
        rightEdgeView.frame.origin = CGPoint(
            x: spaceView.frame.width - rightEdgeView.frame.width,
            y: spaceView.frame.origin.y)
        spaceView.addSubview(rightEdgeView)
    }
    
    private func addStartGameLabel() {
        startGameLabel.frame = spaceView.frame
        startGameLabel.text =  .three
        startGameLabel.textColor = .customRed
        startGameLabel.textAlignment = .center
        startGameLabel.font = .disc
        spaceView.addSubview(startGameLabel)
    }
    
    private func addContainerViews() {
        topContainerView.frame = spaceView.frame
        topContainerView.frame.size.height = spaceView.frame.height / 10
        topContainerView.isHidden = true
        spaceView.addSubview(topContainerView)
        
        bottomContainerView.frame = topContainerView.frame
        bottomContainerView.frame.origin.y = spaceView.frame.height - bottomContainerView.frame.height
        bottomContainerView.isHidden = true
        spaceView.addSubview(bottomContainerView)
    }
    
    private func addDirectionButtons() {
        let size = bottomContainerView.frame.width / 12
        let leftButton = UIButton(
                frame: CGRect(
                x: size,
                y: bottomContainerView.frame.height - size * 3,
                width: size / 2,
                height: size
            )
        )
        leftButton.addTarget(
            self,
            action: #selector(leftButtonPressed),
            for: .touchUpInside
        )
        leftButton.setBackgroundImage(.leftImage, for: .normal)
        leftButton.tintColor = .lightGray
        leftButton.setTitleColor(.darkGray, for: .highlighted)
        bottomContainerView.addSubview(leftButton)

        rightButton.frame = leftButton.frame
        rightButton.frame.origin.x = bottomContainerView.frame.width - size * 1.5
        rightButton.addTarget(
            self,
            action: #selector(rightButtonPressed),
            for: .touchUpInside
        )
        rightButton.setBackgroundImage(.rightImage, for: .normal)
        rightButton.tintColor = .lightGray
        rightButton.setTitleColor(.darkGray, for: .highlighted)
        bottomContainerView.addSubview(rightButton)
    }
    
    private func addShootButton() {
        let size = bottomContainerView.frame.width / 12
        let shootButton = UIButton(
            frame:  CGRect(
                x: bottomContainerView.frame.width / 2 - size / 2,
                y: rightButton.frame.origin.y,
                width: size,
                height: size
            )
        )
        shootButton.addTarget(
            self,
            action: #selector(shootButtonPressed),
            for: .touchUpInside
        )
        shootButton.setBackgroundImage(.shootImage, for: .normal)
        shootButton.tintColor = .lightGray
        shootButton.setTitleColor(.darkGray, for: .highlighted)
        bottomContainerView.addSubview(shootButton)
    }
    
    private func addJumpButton() {
        let size = bottomContainerView.frame.width / 12
        let jumpButton = UIButton(
                frame: CGRect(
                    x: bottomContainerView.frame.width - bottomContainerView.frame.width / 3,
                    y: rightButton.frame.origin.y,
                    width: size,
                    height: size
                )
            )
        jumpButton.addTarget(
            self,
            action: #selector(jumpButtonPressed),
            for: .touchUpInside
        )
        jumpButton.setBackgroundImage(.jumpImage, for: .normal)
        jumpButton.tintColor = .lightGray
        jumpButton.setTitleColor(.darkGray, for: .highlighted)
        bottomContainerView.addSubview(jumpButton)
    }
    
    private func addTapRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        if control == .gyroscope {
            spaceView.addGestureRecognizer(tap)
        }
    }
    
    private func addScoreLabel() {
        let size = topContainerView.frame.height / 4
        let scoreImageView = UIImageView(
            frame: CGRect(
                x: size,
                y: topContainerView.frame.height - size,
                width: size * 1.2,
                height: size
            )
        )
        scoreImageView.image = .scoreImage
        scoreImageView.tintColor = .customBlue
        topContainerView.addSubview(scoreImageView)
        
        scoreLabel.frame = CGRect(
            x: scoreImageView.frame.origin.x + scoreImageView.frame.width * 1.3,
            y: scoreImageView.frame.origin.y + scoreImageView.frame.height / 10,
            width: scoreImageView.frame.width * 2,
            height: scoreImageView.frame.height
        )
        scoreLabel.textColor = .customBlue
        scoreLabel.adjustsFontSizeToFitWidth = true
        scoreLabel.font = .astonaut
        scoreLabel.text = "\(score)"
        topContainerView.addSubview(scoreLabel)
    }
    
    private func addCoinsLabel() {
        let coinsImageView = UIImageView(
            frame: CGRect(
                x: (lifeView.frame.origin.x - scoreLabel.frame.origin.x + scoreLabel.frame.width) / 2,
                y: scoreLabel.frame.origin.y,
                width: scoreLabel.frame.height,
                height: scoreLabel.frame.height
            )
        )
        coinsImageView.image = .coinImage
        coinsImageView.tintColor = .customYellow
        topContainerView.addSubview(coinsImageView)
        
        coinsLabel.frame = coinsImageView.frame
        coinsLabel.frame.origin.x = coinsImageView.frame.origin.x + coinsImageView.frame.width * 1.5
        coinsLabel.textColor = .customYellow
        coinsLabel.adjustsFontSizeToFitWidth = true
        coinsLabel.font = .astonaut
        coinsLabel.text = "\(coins)"
        topContainerView.addSubview(coinsLabel)
    }
    
    private func addLifeView() {
        let lifeImageView = UIImageView(frame: scoreLabel.frame)
        lifeImageView.frame.origin.x = topContainerView.frame.width / 2 - scoreLabel.frame.height / 2
        lifeImageView.frame.size.width = scoreLabel.frame.height * 1.2
        lifeImageView.image = .lifeImage
        lifeImageView.tintColor = .customRed
        topContainerView.addSubview(lifeImageView)
        
        let height = lifeImageView.frame.height / 3
        lifeView.frame.origin = CGPoint(
            x: lifeImageView.frame.origin.x + lifeImageView.frame.width * 1.3,
            y: scoreLabel.frame.origin.y + lifeImageView.frame.height / 2 - height / 2
        )
        lifeView.frame.size = CGSize(
            width: backButton.frame.origin.x - lifeView.frame.origin.x - lifeImageView.frame.width / 2,
            height: height
        )
        lifeView.rounded(radius: lifeView.frame.height / 2)
        lifeView.bordered(width: 1.5)
        lifeView.setBorderColor(lifeImageView.tintColor)
        fullLifeWidth = lifeView.frame.width
        topContainerView.addSubview(lifeView)
    }
    
    private func addBackButton() {
        backButton.frame = CGRect(
            x: topContainerView.frame.width - scoreLabel.frame.height * 2,
            y: scoreLabel.frame.origin.y,
            width: scoreLabel.frame.height,
            height: scoreLabel.frame.height
        )
        backButton.addTarget(
            self,
            action: #selector(backButtonPressed),
            for: .touchUpInside
        )
        backButton.setBackgroundImage(.backImage, for: .normal)
        backButton.tintColor = .lightGray
        backButton.setTitleColor(.darkGray, for: .highlighted)
        topContainerView.addSubview(backButton)
    }
    
    private func addSpaceship() {
        let size = spaceView.frame.width / 6
        spaceshipImageView.frame = CGRect(
            x: spaceView.frame.width / 2 - size / 2,
            y: spaceView.frame.height - size * 3,
            width: size,
            height: size
        )
        normalSizeForSpaceship = spaceshipImageView.frame.size
        spaceshipImageView.contentMode = .scaleToFill
        spaceView.addSubview(spaceshipImageView)
    }
    
    private func addShield() {
        let offset = spaceshipImageView.frame.width / 8
        shieldImageView.frame = CGRect(
            x: spaceshipImageView.frame.origin.x - offset,
            y: spaceshipImageView.frame.origin.y - offset,
            width: spaceshipImageView.frame.width + offset * 2,
            height: spaceshipImageView.frame.height + offset * 2
        )
        shieldImageView.image = shieldImagesArray.first as? UIImage
        shieldImageView.contentMode = .scaleToFill
        shieldImageView.isHidden = true
        spaceView.addSubview(shieldImageView)
    }
    
    private func addFire() {
        let size = spaceshipImageView.frame.width / 6
        fireImageView.frame = CGRect(
            x: spaceView.frame.width / 2 - size / 2,
            y: spaceshipImageView.frame.origin.y + spaceshipImageView.frame.height,
            width: size,
            height: size * 2
        )
        fireImageView.image = fireImagesArray.first as? UIImage
        spaceView.addSubview(fireImageView)
    }
    
    private func addLaser() {
        let size = spaceshipImageView.frame.width / 3
        laserImageView.frame = CGRect(
            x: spaceView.frame.width / 2 - size / 2,
            y: spaceshipImageView.frame.origin.y,
            width: size,
            height: size
        )
        laserImageView.isHidden = true
        laserImageView.image = UIImage(named: user.settings.laser)
        spaceView.addSubview(laserImageView)
    }
    
    private func createItem(_ item: Item) -> UIImageView {
        let size = spaceView.frame.width / 11
        let itemImageView = UIImageView(
            frame: CGRect(
                x: .random(in: leftEdgeView.frame.width...rightEdgeView.frame.origin.x - size),
                y: -size,
                width: size,
                height: size * 0.65
            )
        )
        itemImageView.contentMode = .scaleAspectFit
        
        switch item {
        case .shield:
            itemImageView.frame.size.height = size
            itemImageView.image = shieldImagesArray.first as? UIImage
        case .laser:
            itemImageView.frame.size.height = size
            itemImageView.image = UIImage(named: user.settings.laser)
        case .heart:
            itemImageView.frame.size.width *= 0.8
            itemImageView.image = heartImagesArray.first as? UIImage
        case .coin:
            itemImageView.frame.size.width = itemImageView.frame.height
            itemImageView.image = coinImagesArray.first as? UIImage
        case .star:
            itemImageView.frame.size.width *= 0.8
            itemImageView.image = starImagesArray.first as? UIImage
        }
        itemImageViewsArray.append(itemImageView)
        spaceView.insertSubview(itemImageView, belowSubview: spaceshipImageView)
        return itemImageView
    }
    
    private func createMeteorite() -> UIImageView {
        let minSize = spaceView.frame.width / 14
        let maxSize = spaceView.frame.width / 6
        let size = CGFloat.random(in: minSize...maxSize)
        let meteoriteImageView = UIImageView(
            frame: CGRect(
                x: CGFloat.random(in: leftEdgeView.frame.width...rightEdgeView.frame.origin.x - size),
                y: -size,
                width: size,
                height: size
            )
        )
        if Bool.random() {
            meteoriteImageView.image = firstMeteoriteImagesArray[
                Int.random(in: .zero...firstMeteoriteImagesArray.count - 1)
            ]
        } else {
            meteoriteImageView.image = secondMeteoriteImagesArray[
                Int.random(in: .zero...secondMeteoriteImagesArray.count - 1)
            ]
        }
        meteoriteImageViewsArray.append(meteoriteImageView)
        spaceView.insertSubview(meteoriteImageView, belowSubview: spaceshipImageView)
        return meteoriteImageView
    }
    
    //MARK: - move and animate views funcs
    
    private func animateSpace() {
        let duration = 6.5
        UIView.animate(
            withDuration: duration * speed,
            delay: .zero,
            options: .curveLinear
        ) { [weak self] in
            guard let self = self else { return }
            
            self.moveSpace(.down)
        } completion: { [weak self] _ in
            guard let self = self else { return }
            
            self.moveSpace(.up)
        }
    }
    
    private func moveSpace(_ direction: Direction) {
        if direction == .down {
            topSpaceImageView.frame.origin.y = bottomSpaceImageView.frame.origin.y
            bottomSpaceImageView.frame.origin.y = spaceView.frame.height
        } else {
            if !life {
                repeatButton.isHidden = false
                return
            }
            bottomSpaceImageView.frame.origin.y = spaceView.frame.origin.y
            topSpaceImageView.frame.origin.y = -bottomSpaceImageView.frame.height
            animateSpace()
        }
    }
    
    private func moveLife() {
        let step = 0.25
        if lifeView.frame.width < 1 {
            life = false
        }
        UIView.animate(withDuration: .standartForAnimate) { [weak self] in
            guard let self = self else { return }
            
            self.lifeView.frame.size.width -= step
        }
    }
    
    private func moveSpaceshipWithButtons(_ duration: Direction) {
        let step = CGFloat(15)
        let jumpFactor = 1.2
        let spaceshipCenter = spaceshipImageView.center
        let laserCenter = laserImageView.center
        let fireCenter = fireImageView.center
        
        switch duration {
        case .up:
            if laserImageView.frame.origin.y >= spaceshipImageView.frame.origin.y {
                laserImageView.frame.size.width *= jumpFactor
                laserImageView.frame.size.height *= jumpFactor
                laserImageView.center = laserCenter
            }
            spaceshipImageView.frame.size.width *= jumpFactor
            spaceshipImageView.frame.size.height *= jumpFactor
            spaceshipImageView.center = spaceshipCenter
            
            shieldImageView.frame.size.width *= jumpFactor
            shieldImageView.frame.size.height *= jumpFactor
            shieldImageView.center = spaceshipCenter
            
            fireImageView.frame.size.width *= jumpFactor
            fireImageView.frame.size.height *= jumpFactor
            fireImageView.center = fireCenter
            fireImageView.frame.origin.y += step / 2
        case .down:
            if laserImageView.frame.origin.y >= spaceshipImageView.frame.origin.y {
                laserImageView.frame.size.width /= jumpFactor
                laserImageView.frame.size.height /= jumpFactor
                laserImageView.center = laserCenter
            }
            spaceshipImageView.frame.size.width /= jumpFactor
            spaceshipImageView.frame.size.height /= jumpFactor
            spaceshipImageView.center = spaceshipCenter
            
            shieldImageView.frame.size.width /= jumpFactor
            shieldImageView.frame.size.height /= jumpFactor
            shieldImageView.center = spaceshipCenter
            
            fireImageView.frame.size.width /= jumpFactor
            fireImageView.frame.size.height /= jumpFactor
            fireImageView.center = fireCenter
            fireImageView.frame.origin.y -= step / 2
        case .left:
            if spaceshipImageView.frame.intersects(leftEdgeView.frame) {
                if !shieldImageView.isHidden {
                    shieldImageView.isHidden = true
                    return
                }
                life = false
            }
            if laserImageView.frame.origin.y >= spaceshipImageView.frame.origin.y {
                laserImageView.frame.origin.x -= step
            }
            spaceshipImageView.frame.origin.x -= step
            shieldImageView.frame.origin.x -= step
            fireImageView.frame.origin.x -= step
        case .right:
            if spaceshipImageView.frame.intersects(rightEdgeView.frame) {
                if !shieldImageView.isHidden {
                    shieldImageView.isHidden = true
                    return
                }
                life = false
            }
            if laserImageView.frame.origin.y >= spaceshipImageView.frame.origin.y {
                laserImageView.frame.origin.x += step
            }
            spaceshipImageView.frame.origin.x += step
            shieldImageView.frame.origin.x += step
            fireImageView.frame.origin.x += step
        }
    }
    
    private func animateSpaseshipWithButtons(_ direction: Direction) {
        switch direction {
        case .up:
            if intersectionCheck {
                UIView.animate(withDuration: .second) { [weak self] in
                    guard let self = self else { return }
                    
                    self.intersectionCheck = false
                    self.moveSpaceshipWithButtons(.up)
                } completion: { [weak self]_ in
                    guard let self = self else { return }
                    
                    self.animateSpaseshipWithButtons(.down)
                }
            }
        case .down:
            UIView.animate(withDuration: .second) { [weak self] in
                guard let self = self else { return }
                
                self.moveSpaceshipWithButtons(.down)
            } completion: { [weak self] _ in
                guard let self = self else { return }
                
                self.intersectionCheck = true
            }
        case .right:
            UIView.animate(withDuration: .standartForAnimate) { [weak self] in
                guard let self = self else { return }
                
                self.moveSpaceshipWithButtons(.right)
            }
        case .left:
            UIView.animate(withDuration: .standartForAnimate) { [weak self] in
                guard let self = self else { return }
                
                self.moveSpaceshipWithButtons(.left)
            }
        }
    }
    
    private func moveSpaceshipWithGyroscope(distance: Double) {
        if spaceshipImageView.frame.intersects(leftEdgeView.frame) ||
            spaceshipImageView.frame.intersects(rightEdgeView.frame) {
            if !shieldImageView.isHidden {
                shieldImageView.isHidden = true
                return
            }
            life = false
        }
        if laserImageView.frame.origin.y >= spaceshipImageView.frame.origin.y {
            laserImageView.frame.origin.x += distance
        }
        spaceshipImageView.frame.origin.x += distance
        shieldImageView.frame.origin.x += distance
        fireImageView.frame.origin.x += distance
    }
    
    private func animateSpaceshipWithGyroscope() {
        guard control == .gyroscope,
              motionManager.isAccelerometerAvailable,
              motionManager.isDeviceMotionAvailable else { return }
        
        motionManager.accelerometerUpdateInterval = .second / 10
        motionManager.startAccelerometerUpdates(to: .main) { data, error in
            guard let info = data?.acceleration else { return }
            
            
            UIView.animate(withDuration: .standartForAnimate) { [weak self] in
                guard let self = self else { return }
                
                let step = CGFloat(40)
                self.moveSpaceshipWithGyroscope(distance: info.x * step)
            }
        }
        motionManager.gyroUpdateInterval = .second / 10
        motionManager.startGyroUpdates(to: .main) { [weak self] data, error in
            guard let info = data?.rotationRate,
                  let self = self else { return }
            
            if info.x > 3 {
                self.animateSpaseshipWithButtons(.up)
            }
        }
    }
    
    private func animateShieldAndFire() {
        Timer.scheduledTimer(
            withTimeInterval: .standartForRepeatTimer / 2,
            repeats: true
        ) { [weak self] timer in
            guard let self = self else { return }
            
            self.selectImage(self.fireImageView, in: self.fireImagesArray)
            self.selectImage(self.shieldImageView, in: self.shieldImagesArray)
            
            if !self.life {
                timer.invalidate()
            }
        }
    }
    
    private func shootLaser() {
        if spaceshipImageView.frame.width != normalSizeForSpaceship.width { return }
        if !laserImageView.isHidden {
            SoundManager.shared.playSound(.laser)
            
            UIView.animate(
                withDuration: .second,
                delay: .zero,
                options: .curveLinear
            ) { [weak self] in
                guard let self = self else { return }
                
                self.moveLaser(.up)
            } completion: { [weak self] _ in
                guard let self = self else { return }
                
                self.moveLaser(.down)
            }
        }
    }
    
    private func moveLaser(_ direction: Direction) {
        if direction == .up {
            laserImageView.frame.origin.y = -laserImageView.frame.height
        }
        if direction == .down {
            laserImageView.frame.origin.x = spaceshipImageView.frame.origin.x + spaceshipImageView.frame.width / 2 - laserImageView.frame.width / 2
            laserImageView.frame.origin.y = spaceshipImageView.frame.origin.y
            laserImageView.isHidden = true
        }
    }
    
    private func animateItem(_ item: UIImageView) {
        var phase = AnimationPhase.normal
        let center = item.center
        let normalSize = item.frame.size
        let midSize = CGSize(
            width: normalSize.width * 0.75,
            height: normalSize.height * 0.75
        )
        let minSize = CGSize(
            width: normalSize.width / 2,
            height: normalSize.height / 2
        )
        Timer.scheduledTimer(
            withTimeInterval: .standartForRepeatTimer,
            repeats: true
        ) { [weak self] timer in
            guard let self = self else { return }
            
            if !self.spaceView.contains(item) {
                timer.invalidate()
            }
            if self.shieldImagesArray.contains(item.image) ||
                item.image == self.laserImageView.image {
                
                UIView.animate(withDuration: .standartForAnimate) {
                    switch phase {
                    case .normal:
                        item.frame.size = normalSize
                        phase = .medium
                    case .medium:
                        item.frame.size = midSize
                        phase = .small
                    case .small:
                        item.frame.size = minSize
                        phase = .retrieval
                    case .retrieval:
                        item.frame.size = midSize
                        phase = .normal
                    }
                    item.center = center
                }
                self.selectImage(item, in: self.shieldImagesArray)
            }
            if self.heartImagesArray.contains(item.image) {
                self.selectImage(item, in: self.heartImagesArray)
            }
            if self.coinImagesArray.contains(item.image) {
                self.selectImage(item, in: self.coinImagesArray)
            }
            if self.starImagesArray.contains(item.image) {
                self.selectImage(item, in: self.starImagesArray)
            }
        }
    }
    
    private func moveItem() {
        guard life,
              let randomItem = Item.allCases.randomElement() else { return }
        
        switch randomItem {
        case .heart where lifeView.frame.width > fullLifeWidth * 0.75,
             .shield where !shieldImageView.isHidden,
             .laser where !laserImageView.isHidden:
            moveItem()
            return
        default: break
        }
        var item = UIImageView()
        if lifeView.frame.width < fullLifeWidth * 0.3 {
            item = createItem(.heart)
        } else {
            item = createItem(randomItem)
        }
        let duration = 9.5
        
        UIView.animate(
            withDuration: duration * speed,
            delay: .zero,
            options: .curveLinear
        ) { [weak self] in
            guard let self = self else { return }
            
            item.frame.origin.y = self.spaceView.frame.height
        } completion: { [weak self] _ in
            guard let self = self else { return }
            
            item.removeFromSuperview()
            self.itemImageViewsArray = self.itemImageViewsArray.filter { $0 != item }
            self.moveItem()
        }
        animateItem(item)
    }
    
    private func animateMeteorite(_ meteorite: UIImageView) {
        let timeInterval = TimeInterval.random(in: 0.05...0.1)
        
        Timer.scheduledTimer(
            withTimeInterval: timeInterval,
            repeats: true
        ) { [weak self] timer in
            guard let self = self else { return }
            
            if !self.spaceView.contains(meteorite) {
                timer.invalidate()
            }
            if self.firstMeteoriteImagesArray.contains(meteorite.image) {
                self.selectImage(meteorite, in: self.firstMeteoriteImagesArray)
            } else {
                self.selectImage(meteorite, in: self.secondMeteoriteImagesArray)
            }
        }
    }
    
    private func moveMeteorite() {
        if !life { return }
        let meteorite = createMeteorite()
        let duration = TimeInterval.random(in: 4...8)
        
        UIView.animate(
            withDuration: duration * speed,
            delay: .zero,
            options: .curveLinear
        ) { [weak self] in
            guard let self = self else { return }
            
            meteorite.frame.origin.y = self.spaceView.frame.height
            
            Timer.scheduledTimer(
                withTimeInterval: .standartForRepeatTimer,
                repeats: true
            ) { [weak self] timer in
                guard let self = self else { return }
                
                if let meteoritePresentationFrame = meteorite.layer.presentation()?.frame,
                   meteoritePresentationFrame.origin.y > self.spaceView.frame.height / 5 {
                    self.moveMeteorite()
                    timer.invalidate()
                }
            }
        } completion: { [weak self] _ in
            guard let self = self else { return }
            
            meteorite.removeFromSuperview()
            self.meteoriteImageViewsArray = self.meteoriteImageViewsArray.filter { $0 != meteorite }
        }
        animateMeteorite(meteorite)
    }
}
