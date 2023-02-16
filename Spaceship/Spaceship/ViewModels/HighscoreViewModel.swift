
import Foundation
import RxCocoa
import RxSwift

final class HighscoreViewModel {
    
    private var dataSource = BehaviorRelay<[ResultCellViewModel]>(value: [])
    
    func getDataSource() -> BehaviorRelay<[ResultCellViewModel]>? {
        guard let results = StorageManager.shared.loadResults() else { return nil }
                
        var viewModelsArray = [ResultCellViewModel]()
        
        results.enumerated().forEach { index, result in
            viewModelsArray.append(
                ResultCellViewModel(
                    result: result,
                    index: index
                )
            )
        }
        dataSource.accept(viewModelsArray)
        return dataSource
    }
}
