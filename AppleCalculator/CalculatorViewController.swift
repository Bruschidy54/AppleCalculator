//
//  CalculatorViewController.swift
//  AppleCalculator
//
//  Created by Dylan Bruschi on 11/30/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet var calculatorButtons: [UIButton]!
    @IBOutlet var numberLabel: UILabel!
    
    // MARK: Global Variables
    
    var performingOperation = false
    var displayNumber: Double? = 0
    var previousNumber: Double? = nil
    var justTappedEqual = false
    
    // operationType tracks which operation is being implemented; highlightedOperation tracks which button is highlighted. In a future release, there should be a custom button class that includes robust button highlighting functionality rather than a simple UIButton extension
    var operationType: OperationType = .none
    var highlightedOperation: OperationType = .none
    
    
    // MARK: Button Actions
    
    @IBAction func onNumberTapped(_ sender: UIButton) {
        // Numbers flash animation on tap
        DispatchQueue.main.async {
            sender.flash(withTitleColor: UIColor.white, andBackgroundColor: UIColor.lightGray)
        }
        
        // If there was previously an error, we will treat subsequent number taps as if we had just performed an operation
        if displayNumber == nil {
            performingOperation = true
            
        }
        
        // Clears the number and operation queue if the equal button was just tapped. The Apple Calculator does not have this feature, though this makes more sense to me
        if justTappedEqual {
            previousNumber = nil
            operationType = .none
            justTappedEqual = false
        }
        
            // Each number's tag is equal to its number value
        if performingOperation == true {
            performingOperation = false
            displayNumber = Double(sender.tag)
            unhighlightOperationButton(withOperationType: highlightedOperation)
            do {
            try showNumberOnLabel(display: displayNumber)
            } catch {
                print(error)
                numberLabel.text = "Error"
                displayNumber = nil
            }
        } else {
            if numberLabel.text == "0" {
                displayNumber = Double(sender.tag)
                do {
                    try showNumberOnLabel(display: displayNumber)
                } catch {
                    print(error)
                    numberLabel.text = "Error"
                    displayNumber = nil
                }
            } else {
                // The numberLabel string should only have 9 number digits
                let numberStringWithoutCommasAndDecimals = numberLabel.text?.filter { $0 != "," || $0 != "." || $0 != "-"}
                guard (numberStringWithoutCommasAndDecimals?.count as! Int) <= 10 else {
                    return
                }
                
                // Add tapped number to string
                let numberStringWithoutCommas = numberLabel.text?.filter { $0 != "," }
                let newDisplayString = numberStringWithoutCommas! + String(sender.tag)
                let newDisplayDouble = Double(newDisplayString)!
                displayNumber = newDisplayDouble.rounded(toPlaces: 9)
                
                // This handles an error where 0s followings a decimal point were being deleted
                if (numberStringWithoutCommas?.contains("."))! && String(sender.tag) == "0" {
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = NumberFormatter.Style.decimal
                    numberLabel.text = newDisplayString
                    return
                }
                do {
                try showNumberOnLabel(display: displayNumber)
                } catch {
                    print(error)
                    numberLabel.text = "Error"
                    displayNumber = nil
                }
                
            }
        }
    }
    
    @IBAction func onOperationTapped(_ sender: UIButton) {
        switch sender.tag {
        case 10: // All Clear
               justTappedEqual = false
            flashOperation(button: sender)
            unhighlightOperationButton(withOperationType: operationType)
               do {
             try showNumberOnLabel(display: 0)
               } catch {
                print(error)
                numberLabel.text = "Error"
                displayNumber = nil
               }
            previousNumber = nil
            displayNumber = 0
            operationType = .none
            break
        case 11: // Positive/Negative
            flashOperation(button: sender)
            // Will not perform if last operation resulted in error
            guard displayNumber != nil else {
                return
            }
            performingOperation = true
            // By choice, this operation will just perform on the display number
            displayNumber = displayNumber! * -1
            do {
            try showNumberOnLabel(display: displayNumber)
            } catch {
                print(error)
                numberLabel.text = "Error"
                displayNumber = nil
            }
            break
        case 12: // Percent
            flashOperation(button: sender)
            // Will not perform if last operation resulted in error
            guard displayNumber != nil else {
                return
            }
            performingOperation = true
            // By choice, this operation will just perform on the display number
            displayNumber = displayNumber!/100
            do {
            try showNumberOnLabel(display: displayNumber)
            } catch {
                numberLabel.text = "Error"
                displayNumber = nil
                print(error)
            }
            break
        case 13: // Division
            
            guard displayNumber != nil else {
                return
            }
            
               justTappedEqual = false
            // Button will flash if already selected, else it will highlight
            if highlightedOperation == .division {
                highlightOperation(button: sender, flash: true)
            } else {
                highlightOperation(button: sender, flash: false)
                unhighlightOperationButton(withOperationType: highlightedOperation)
            }
            if operationType != .none && performingOperation == false {
                do {
                displayNumber = try calculateOperation(firstNumber: previousNumber, secondNumber: displayNumber, operation: .division)
                try showNumberOnLabel(display: displayNumber)
                } catch {
                    print(error)
                    numberLabel.text = "Error"
                    displayNumber = nil
                }
            }
            highlightedOperation = .division
            previousNumber = displayNumber
            operationType = .division
            performingOperation = true
            break
        case 14: // Multiplication
            
            guard displayNumber != nil else {
                return
            }
            
               justTappedEqual = false
            if highlightedOperation == .multiplication {
                highlightOperation(button: sender, flash: true)
            } else {
                highlightOperation(button: sender, flash: false)
                unhighlightOperationButton(withOperationType: highlightedOperation)
            }
            if operationType != .none && performingOperation == false {
                do {
                displayNumber = try calculateOperation(firstNumber: previousNumber, secondNumber: displayNumber, operation: .multiplication)
                try showNumberOnLabel(display: displayNumber)
                } catch {
                    print(error)
                    numberLabel.text = "Error"
                    displayNumber = nil
                }
            }
            highlightedOperation = .multiplication
            previousNumber = displayNumber
            operationType = .multiplication
            performingOperation = true
            break
        case 15: // Subtraction
            
            guard displayNumber != nil else {
                return
            }
            
               justTappedEqual = false
             // Button will flash if already selected, else it will highlight
            if highlightedOperation == .subtraction {
                highlightOperation(button: sender, flash: true)
            } else {
                highlightOperation(button: sender, flash: false)
                unhighlightOperationButton(withOperationType: highlightedOperation)
            }
            if operationType != .none && performingOperation == false {
                do {
                displayNumber = try calculateOperation(firstNumber: previousNumber, secondNumber: displayNumber, operation: .subtraction)
                try showNumberOnLabel(display: displayNumber)
                } catch {
                    print(error)
                    numberLabel.text = "Error"
                    displayNumber = nil
                }
            }
            highlightedOperation = .subtraction
            previousNumber = displayNumber
            operationType = .subtraction
            performingOperation = true
            break
        case 16: // Addition
            
            guard displayNumber != nil else {
                return
            }
            
               justTappedEqual = false
            
             // Button will flash if already selected, else it will highlight
            if highlightedOperation == .addition {
                highlightOperation(button: sender, flash: true)
            } else {
                highlightOperation(button: sender, flash: false)
            unhighlightOperationButton(withOperationType: highlightedOperation)
            }
            if operationType != .none && performingOperation == false {
               
                do {
                    displayNumber = try calculateOperation(firstNumber: previousNumber, secondNumber: displayNumber, operation: .addition)
                try showNumberOnLabel(display: displayNumber)
                } catch {
                    print(error)
                    numberLabel.text = "Error"
                    displayNumber = nil
                }
            }
            highlightedOperation = .addition
            previousNumber = displayNumber
            operationType = .addition
            performingOperation = true
            break
        case 17: // Equal
            
            guard displayNumber != nil else {
                return
            }
            
            justTappedEqual = true
            flashOperation(button: sender)
            unhighlightOperationButton(withOperationType: operationType)
            highlightedOperation = .none
            do {
            displayNumber = try calculateOperation(firstNumber: previousNumber, secondNumber: displayNumber, operation: operationType)
            try showNumberOnLabel(display: displayNumber)
            } catch {
                print(error)
                numberLabel.text = "Error"
                displayNumber = nil
            }
            performingOperation = true
            break
        case 18: // Decimal Point
            
            guard displayNumber != nil else {
                return
            }
            
            flashOperation(button: sender)
            
            // Prevents bug where hitting . after performing operation does not register new number
            guard performingOperation == false else {
                numberLabel.text = "0."
                displayNumber = 0
                performingOperation = false
                unhighlightOperationButton(withOperationType: highlightedOperation)
                return
            }
            
            
            // Makes sure label does not exceed max length
            let numberStringWithoutCommasAndDecimals = numberLabel.text?.filter { $0 != "," || $0 != "." || $0 != "-"}
            guard !(numberLabel.text?.contains("."))! && (numberStringWithoutCommasAndDecimals?.count as! Int) <= 10  && numberLabel.text != "Error" else {
                return
            }
            
            // Clears the number and operation queue if the equal button was just tapped. The Apple Calculator does not have this feature, though this makes more sense to me
            if justTappedEqual {
                previousNumber = nil
                operationType = .none
                justTappedEqual = false
            }
 
            numberLabel.text = numberLabel.text! + "."
            break
        default:
            break
        }
    }
    
    // Need to round buttons only after contraints are put into place
    override func viewDidLayoutSubviews() {
        for button in calculatorButtons {
            button.makeCircular()
        }
    }

    // MARK: Button Animation Methods
    // Should move this functionality to custom button class in future release
    
    func highlightOperation(button: UIButton, flash: Bool) {
        if flash {
            DispatchQueue.main.async {
              button.flash(withTitleColor: UIColor.white, andBackgroundColor: UIColor(red: 247/255, green: 146/255, blue: 49/255, alpha: 1.00))
            }
        } else {
            DispatchQueue.main.async {
                button.highlight(withTitleColor: UIColor(red: 247/255, green: 146/255, blue: 49/255, alpha: 1.00), andBackgroundColor: UIColor.white)
            }
        }
    }
    
    func unhighlightOperationButton(withOperationType previousOperationType: OperationType) {
        var previousButton: UIButton? = nil
        switch  previousOperationType {
        case .none:
            break
        case .addition:
            previousButton = (self.view.viewWithTag(16) as! UIButton)
            break
        case .subtraction:
            previousButton = (self.view.viewWithTag(15) as! UIButton)
            break
        case .multiplication:
            previousButton = (self.view.viewWithTag(14) as! UIButton)
            break
        case .division:
            previousButton = (self.view.viewWithTag(13) as! UIButton)
            break
        }
        highlightedOperation = .none
        DispatchQueue.main.async {
            if previousButton != nil {
                previousButton?.highlight(withTitleColor: UIColor.white, andBackgroundColor: UIColor(red: 247/255, green: 146/255, blue: 49/255, alpha: 1.00))
            }
        }
    }
    
    func flashOperation(button: UIButton) {
        switch button.tag {
        case 10, 11, 12:
            DispatchQueue.main.async {
                button.flash(withTitleColor: UIColor.black, andBackgroundColor: UIColor.white)
            }
            break
        case 17:
            DispatchQueue.main.async {
                button.flash(withTitleColor: UIColor(red: 247/255, green: 146/255, blue: 49/255, alpha: 1.00), andBackgroundColor: UIColor.white)
            }
            break
        case 18:
            DispatchQueue.main.async {
                button.flash(withTitleColor: UIColor.white, andBackgroundColor: UIColor.lightGray)
            }
            break
        default:
            break
        }
    }
    
    // MARK: Label UI Methods
    
    func showNumberOnLabel(display: Double?) throws {
        
        guard let number = display else {
            numberLabel.text = "Error"
            return
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 9
        // Use scientific notation if number is too large or small
        if abs(number) >= 1000000000 || abs(number) <=  0.000000001 && number != 0 {
            numberFormatter.numberStyle = NumberFormatter.Style.scientific
            numberFormatter.exponentSymbol = "e"
        } else {
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
        }
        
        
        numberLabel.text = numberFormatter.string(from: NSNumber(value: number))
    }
    
    // MARK: Math
    
    //TO DO: Need to separate math from UI
    
    func calculateOperation(firstNumber: Double?, secondNumber: Double?, operation: OperationType) throws -> Double? {
        
        guard let second = secondNumber else {
            return nil
        }
        
        var result: Double = 0
        
        // If previous number is nil, the Apple Calculator defaults to performing the operation with the display number as the previous number
        if operation == .division && secondNumber != 0 {
            if let first = firstNumber {
                result = first / second
            } else {
                result = second / second
            }
        } else if operation == .division {
            // Catches divide by zero error
            throw OperationError.divideByZero
        } else if operation == .multiplication {
            if let first = firstNumber {
                result = first * second
            } else {
                result = second * second
            }
        } else if operation == .subtraction {
            if let first = firstNumber {
                result = first - second
            } else {
                result = second - second
            }
        } else if operation == .addition {
            if let first = firstNumber {
                result = first + second
            } else {
                result = second + second
            }
        }
        
        // Prevents number overflow error
        guard abs(result) <= pow(10, 160) else {
            throw OperationError.overflow
        }
        
        return result
    }
}

// MARK: UIButton Extension

extension UIButton {
    
    func makeCircular() {
        self.layer.cornerRadius = self.bounds.size.height / 2.0
        self.clipsToBounds = true
    }
    
    // Animates button colors to parameter colors
    func highlight(withTitleColor titleColor: UIColor, andBackgroundColor backgroundColor: UIColor) {
        UIView.transition(with: self, duration: 0.25, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            self.setTitleColor(titleColor, for: UIControlState.normal)
            self.backgroundColor = backgroundColor
        }, completion: nil)
        
    }
    
    // Animates button colors to parameter colors and reverses
    func flash(withTitleColor titleColor: UIColor, andBackgroundColor backgroundColor: UIColor) {
        let originalTitleColor = self.titleLabel?.textColor
        let originalBackgroundColor = self.backgroundColor
        
        UIView.transition(with: self, duration: 0.2, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            self.setTitleColor(titleColor, for: UIControlState.normal)
            self.backgroundColor = backgroundColor
        }, completion: { completed in
            if completed {
                UIView.transition(with: self, duration: 0.2, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                    self.setTitleColor(originalTitleColor, for: UIControlState.normal)
                    self.backgroundColor = originalBackgroundColor
                }, completion: nil)}
        })
    }
}

// MARK: String Extension

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[Range(start ..< end)])
    }
}

// MARK: Double Extension

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
