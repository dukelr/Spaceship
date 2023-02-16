//
//  ResultCellViewModel.swift
//  H10.2
//
//  Created by duke on 2/9/23.
//

import Foundation

final class ResultCellViewModel {
    
    private let result: Result
    private let index: Int
    
    init(result: Result, index: Int) {
        self.result = result
        self.index = index
    }
    
    func getResult() -> Result {
        result
    }
    
    func getIndex() -> Int {
        index
    }
}
