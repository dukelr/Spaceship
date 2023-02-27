
import Foundation
import RxCocoa
import RxSwift

final class HighscoreViewModel {
    typealias DataSource = BehaviorRelay<[ResultCellViewModel]>
    
    private(set) var dataSource = DataSource(value: [])
    private let disposeBag = DisposeBag()
    var sound: Bool?
    
    init() {
        createDataSource()
    }
    
    private func createDataSource() {
        var viewModelsArray = [ResultCellViewModel]()

        guard let results = StorageManager.shared.loadResults() else { return }

        results.enumerated().forEach { index, result in
            viewModelsArray.append(
                ResultCellViewModel(
                    result: result,
                    index: index
                )
            )
        }
        dataSource.accept(viewModelsArray)
    }
    
    func setupDataSource(for tableView: UITableView) {
        dataSource.bind(
            to: tableView.rx.items(
                cellIdentifier: ResultTableViewCell.identifier,
                cellType: ResultTableViewCell.self
            )
        ) { index, model, cell in
            cell.configure(with: model)
        }.disposed(by: disposeBag)
    }
}
