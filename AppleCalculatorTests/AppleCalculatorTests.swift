//
//  AppleCalculatorTests.swift
//  AppleCalculatorTests
//
//  Created by Dylan Bruschi on 11/29/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import XCTest
@testable import AppleCalculator

class AppleCalculatorTests: XCTestCase {
    
    
    func testCalculateOperation() {
        
        let viewController = CalculatorViewController()
        
        var first: Double? = 0
        var second: Double? = 0
        
        XCTAssertThrowsError(try viewController.calculateOperation(firstNumber: first, secondNumber: second, operation: .division), "Divide by zero error") { (error) in
            XCTAssertEqual(error as? OperationError, OperationError.divideByZero)
        }
        
        first = pow(10.0, 100)
        second = pow(10.0, 100)
        
        XCTAssertThrowsError(try viewController.calculateOperation(firstNumber: first, secondNumber: second, operation: .multiplication), "Overflow error") { (error) in
            XCTAssertEqual(error as? OperationError, OperationError.overflow)
        }
        
        first = 7.0
        second = 3.5
        
          XCTAssertEqual(try viewController.calculateOperation(firstNumber: first, secondNumber: second, operation: .division), 2, "Division error")
        
        XCTAssertEqual(try viewController.calculateOperation(firstNumber: first, secondNumber: second, operation: .multiplication), 24.5, "Multiplication error")
        
        XCTAssertEqual(try viewController.calculateOperation(firstNumber: first, secondNumber: second, operation: .subtraction), 3.5, "Subtraction error")
        
        
        XCTAssertEqual(try viewController.calculateOperation(firstNumber: first, secondNumber: second, operation: .addition), 10.5, "Addition error")
        
        first = nil
        
        XCTAssertEqual(try viewController.calculateOperation(firstNumber: first, secondNumber: second, operation: .division), 1, "Division error")
        
        XCTAssertEqual(try viewController.calculateOperation(firstNumber: first, secondNumber: second, operation: .multiplication), 12.25, "Multiplication error")
        
        XCTAssertEqual(try viewController.calculateOperation(firstNumber: first, secondNumber: second, operation: .subtraction), 0, "Subtraction error")
        
        
        XCTAssertEqual(try viewController.calculateOperation(firstNumber: first, secondNumber: second, operation: .addition), 7, "Addition error")
        
        second = nil
        
        XCTAssertEqual(try viewController.calculateOperation(firstNumber: first, secondNumber: second, operation: .division), nil, "Nil error")
        
        XCTAssertEqual(try viewController.calculateOperation(firstNumber: first, secondNumber: second, operation: .multiplication), nil, "Nil error")
        
        
        XCTAssertEqual(try viewController.calculateOperation(firstNumber: first, secondNumber: second, operation: .subtraction), nil, "Nil error")
        
        
        XCTAssertEqual(try viewController.calculateOperation(firstNumber: first, secondNumber: second, operation: .addition), nil, "Nil error")
        
    }
    
    
    
}
