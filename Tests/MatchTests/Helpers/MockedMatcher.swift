//
//  MockedMatcher.swift
//  Match
//
//  Created by Michal on 19/10/2021.
//

@testable import Match

struct MockedMatcher<ResultType>: Matcher {
    let matcherName: String = "MockedMatcher"
    let expectation: Expectation<ResultType>
    let sourceCodeLocation: SourceCodeLocation
    
    var messageToReturn: String = ""
    var evaluationStatusToReturn: EvaluationStatus = .passed
    var onEvaluate: (() -> Void)?
    
    init(expectation: Expectation<ResultType>, sourceCodeLocation: SourceCodeLocation = MockedData.mockedSourceCodeLocation()) {
        self.expectation = expectation
        self.sourceCodeLocation = sourceCodeLocation
    }
    
    func evaluate() -> EvaluationResult {
        onEvaluate?()
        
        return EvaluationResult(
            message: messageToReturn,
            evaluationStatus: evaluationStatusToReturn,
            evaluationContext: evaluationContext
        )
    }
}
