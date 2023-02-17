
import Foundation
import RxCocoa
import RxSwift

final class HighscoreViewModel {
    
    private(set) var dataSource = BehaviorRelay<[ResultCellViewModel]>(value: [])
    
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
}
