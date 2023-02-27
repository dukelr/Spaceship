
import UIKit
import RxSwift
import RxCocoa

final class HighscoreViewController: UIViewController {

    //MARK: - IBOutlets

    @IBOutlet weak var resultTableView: UITableView!
    
    //MARK: - var/let
    
    static let identifier = "HighscoreViewController"
    var viewModel = HighscoreViewModel()
    
    //MARK: - lifecycle funcs

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setupDataSource(for: resultTableView)
    }
    
    //MARK: - IBActions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        playSoundButton()
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - flow funcs
    
    private func playSoundButton() {
        if let sound = viewModel.sound,
           sound {
            SoundManager.shared.playSound(.button)
        }
    }
}

//MARK: - Extensions

extension HighscoreViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.height / CGFloat(Int.countResults)
    }
}
