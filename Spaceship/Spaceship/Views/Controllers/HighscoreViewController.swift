
import UIKit
import RxSwift
import RxCocoa

final class HighscoreViewController: UIViewController {

    //MARK: - IBOutlets

    @IBOutlet weak var resultTableView: UITableView!
    
    //MARK: - var/let
    
    static let identifier = "HighscoreViewController"
    private let viewModel = HighscoreViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - lifecycle funcs

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }
    
    //MARK: - IBActions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        SoundManager.shared.playSound(.button)
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - flow funcs

    private func setupRx() {        
        viewModel.dataSource.bind(
            to: resultTableView.rx.items(
                cellIdentifier: ResultTableViewCell.identifier,
                cellType: ResultTableViewCell.self
            )
        ) { index, model, cell in
            cell.configure(with: model)
        }.disposed(by: disposeBag)
    }
}

//MARK: - Extensions

extension HighscoreViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.height / CGFloat(Int.countResults)
    }
}
