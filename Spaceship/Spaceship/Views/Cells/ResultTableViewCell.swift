
import UIKit

private extension String {
    static let fast = "hare"
}

final class ResultTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    //MARK: - var/let
    
    static let identifier = "ResultTableViewCell"
    
    //MARK: - flow funcs
    
    func configure(with viewModel: ResultCellViewModel) {
        nicknameLabel.text = viewModel.result.nickname
        scoreLabel.text = "\(viewModel.result.score)"
        dateLabel.text = viewModel.result.date
        placeLabel.text = "\(viewModel.index + 1)"
        
        if viewModel.result.speed == .fast {
            speedLabel.text = .localized(.fast)
        } else {
            speedLabel.text = .localized(.slow)
        }
        switch viewModel.index {
        case 0:
            placeLabel.textColor = .customGreen
        case 1:
            placeLabel.textColor = .customYellow
        case 2:
            placeLabel.textColor = .customRed
        default:
            placeLabel.textColor = .lightGray
            placeLabel.font = .astonaut
        }
    }
}
