
import Foundation

final class ResultCellViewModel {
    
    private(set) var result: Result
    private(set) var index: Int
    
    init(result: Result, index: Int) {
        self.result = result
        self.index = index
    }
}
