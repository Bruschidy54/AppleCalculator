//
//  OperationError.swift
//  AppleCalculator
//
//  Created by Dylan Bruschi on 2/20/18.
//  Copyright © 2018 Dylan Bruschi. All rights reserved.
//

import Foundation

enum OperationError: Error {
    case divideByZero
    case overflow
    case unexpected
}
