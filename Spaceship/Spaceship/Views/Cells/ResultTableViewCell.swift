
import UIKit

private extension String {
    static let fast = "hare"
}

class ResultTableViewCell: UITableViewCell {

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
        let result = viewModel.getResult()
        let index = viewModel.getIndex()
        
        print(index)
        nicknameLabel.text = result.nickname
        scoreLabel.text = "\(result.score)"
        dateLabel.text = result.date
        placeLabel.text = "\(index + 1)"
        
        if result.speed == .fast {
            speedLabel.text = "Fast"
        } else {
            speedLabel.text = "Slow"
        }
        switch index {
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
//
//    func configure(with result: Result, indexCell: Int){
//        nicknameLabel.text = result.nickname
//        scoreLabel.text = "\(result.score)"
//        dateLabel.text = result.date
//        placeLabel.text = "\(indexCell + 1)"
//
//        if result.speed == "hare" {
//            speedLabel.text = "Fast"
//        } else {
//            speedLabel.text = "Slow"
//        }
//        switch indexCell {
//        case 0:
//            placeLabel.textColor = .customGreen
//        case 1:
//            placeLabel.textColor = .customYellow
//        case 2:
//            placeLabel.textColor = .customRed
//        default:
//            placeLabel.textColor = .lightGray
//            placeLabel.font = .astonaut
//        }
//    }
}
