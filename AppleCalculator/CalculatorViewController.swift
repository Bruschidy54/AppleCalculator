//
//  CalculatorViewController.swift
//  AppleCalculator
//
//  Created by Dylan Bruschi on 11/30/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    
    
    @IBOutlet var calculatorButtons: [UIButton]!
    @IBOutlet var numberLabel: UILabel!
    
    var performingOperation = false
    var operationType: OperationType = .none
    var highlightedOperation: OperationType = .none
    var displayNumber: Double = 0
    var previousNumber: Double? = nil
    
    
    @IBAction func onNumberTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            sender.flash(withTitleColor: UIColor.white, andBackgroundColor: UIColor.lightGray)
        }
        
        if numberLabel.text == "Error" {
            performingOperation = true
            
        }
        
        if performingOperation == true {
            performingOperation = false
            displayNumber = Double(sender.tag)
            unhighlightOperationButton(withOperationType: highlightedOperation)
            showNumberOnLabel(number: displayNumber)
        } else {
            if numberLabel.text == "0" {
                displayNumber = Double(sender.tag)
                showNumberOnLabel(number: displayNumber)
            } else {
                let numberStringWithoutCommasAndDecimals = numberLabel.text?.filter { $0 != "," || $0 != "." || $0 != "-"}
                guard (numberStringWithoutCommasAndDecimals?.count as! Int) <= 10 else {
                    return
                }
                
                let numberStringWithoutCommas = numberLabel.text?.filter { $0 != "," }
                let newDisplayString = numberStringWithoutCommas! + String(sender.tag)
                let newDisplayDouble = Double(newDisplayString)!
                displayNumber = newDisplayDouble.rounded(toPlaces: 9)
                if newDisplayString[newDisplayString.count - 1] == "0" && newDisplayString[newDisplayString.count - 2] == "." {
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = NumberFormatter.Style.decimal
                    numberLabel.text = "\(displayNumber)"
                    return
                }
                showNumberOnLabel(number: displayNumber)
                
            }
        }
    }
    
    @IBAction func onOperationTapped(_ sender: UIButton) {
        print(highlightedOperation)
        switch sender.tag {
        case 10: // All Clear
            flashOperation(button: sender)
            unhighlightOperationButton(withOperationType: operationType)
            showNumberOnLabel(number: 0)
            previousNumber = nil
            displayNumber = 0
            operationType = .none
            break
        case 11: // Positive/Negative
            flashOperation(button: sender)
            guard numberLabel.text != "Error" else {
                return
            }
            performingOperation = true
            displayNumber = displayNumber * -1
            showNumberOnLabel(number: displayNumber)
            break
        case 12: // Percent
            flashOperation(button: sender)
            guard numberLabel.text != "Error" else {
                return
            }
            performingOperation = true
            displayNumber = displayNumber/100
            showNumberOnLabel(number: displayNumber)
            break
        case 13: // Division
            if highlightedOperation == .division {
                highlightOperation(button: sender, flash: true)
            } else {
                highlightOperation(button: sender, flash: false)
                unhighlightOperationButton(withOperationType: highlightedOperation)
            }
            if operationType != .none && performingOperation == false {
                calculateOperation()
            }
            highlightedOperation = .division
            previousNumber = displayNumber
            operationType = .division
            performingOperation = true
            break
        case 14: // Multiplication
            if highlightedOperation == .multiplication {
                highlightOperation(button: sender, flash: true)
            } else {
                highlightOperation(button: sender, flash: false)
                unhighlightOperationButton(withOperationType: highlightedOperation)
            }
            if operationType != .none && performingOperation == false {
                calculateOperation()
            }
            highlightedOperation = .multiplication
            previousNumber = displayNumber
            operationType = .multiplication
            performingOperation = true
            break
        case 15: // Subtraction
            if highlightedOperation == .subtraction {
                highlightOperation(button: sender, flash: true)
            } else {
                highlightOperation(button: sender, flash: false)
                unhighlightOperationButton(withOperationType: highlightedOperation)
            }
            if operationType != .none && performingOperation == false {
                calculateOperation()
            }
            highlightedOperation = .subtraction
            previousNumber = displayNumber
            operationType = .subtraction
            performingOperation = true
            break
        case 16: // Addition
            if highlightedOperation == .addition {
                highlightOperation(button: sender, flash: true)
            } else {
                highlightOperation(button: sender, flash: false)
            unhighlightOperationButton(withOperationType: highlightedOperation)
            }
            if operationType != .none && performingOperation == false {
                calculateOperation()
            }
            highlightedOperation = .addition
            previousNumber = displayNumber
            operationType = .addition
            performingOperation = true
            break
        case 17: // Equal
            flashOperation(button: sender)
            unhighlightOperationButton(withOperationType: operationType)
            highlightedOperation = .none
            calculateOperation()
            performingOperation = true
            break
        case 18: // Decimal Point
            flashOperation(button: sender)
            let numberStringWithoutCommasAndDecimals = numberLabel.text?.filter { $0 != "," || $0 != "." || $0 != "-"}
            guard !(numberLabel.text?.contains("."))! && (numberStringWithoutCommasAndDecimals?.count as! Int) <= 10  && numberLabel.text != "Error" else {
                return
            }
            
            if performingOperation == true {
                numberLabel.text = "0"
                displayNumber = 0
            }
            numberLabel.text = numberLabel.text! + "."
            break
        default:
            break
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        for button in calculatorButtons {
            button.makeCircular()
        }
    }

    
    
    func highlightOperation(button: UIButton, flash: Bool) {
        if flash {
            DispatchQueue.main.async {
                UIView.transition(with: button, duration: 0.2, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                    button.titleLabel?.textColor = UIColor.white
                    button.backgroundColor = UIColor(red: 247/255, green: 146/255, blue: 49/255, alpha: 1.00)
                }, completion: { completed in
                    if completed {
                        UIView.transition(with: button, duration: 0.2, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                            button.titleLabel?.textColor = UIColor(red: 247/255, green: 146/255, blue: 49/255, alpha: 1.00)
                            button.backgroundColor = UIColor.white
                        }, completion: nil)}
                })
            }
        } else {
            DispatchQueue.main.async {
                button.highlight(withTitleColor: UIColor(red: 247/255, green: 146/255, blue: 49/255, alpha: 1.00), andBackgroundColor: UIColor.white)
            }
        }
    }
    
    func unhighlightOperationButton(withOperationType previousOperationType: OperationType) {
        var previousButton: UIButton? = nil
        switch  previousOperationType{
        case .none:
            break
        case .addition:
            previousButton = self.view.viewWithTag(16) as! UIButton
            break
        case .subtraction:
            previousButton = self.view.viewWithTag(15) as! UIButton
            break
        case .multiplication:
            previousButton = self.view.viewWithTag(14) as! UIButton
            break
        case .division:
            previousButton = self.view.viewWithTag(13) as! UIButton
        default:
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
    
    func calculateOperation() {
        guard numberLabel.text != "Error" else {
            return
        }
        if operationType == .division && displayNumber != 0 {
            if let previous = previousNumber {
                displayNumber = previous / displayNumber
            } else {
                displayNumber = displayNumber / displayNumber
            }
        } else if operationType == .division {
            numberLabel.text = "Error"
            return
        } else if operationType == .multiplication {
            if let previous = previousNumber {
                displayNumber = previous * displayNumber
            } else {
                displayNumber = displayNumber * displayNumber
            }
        } else if operationType == .subtraction {
            if let previous = previousNumber {
                displayNumber = previous - displayNumber
            } else {
                displayNumber = displayNumber - displayNumber
            }
        } else if operationType == .addition {
            if let previous = previousNumber {
                displayNumber = previous + displayNumber
            } else {
                displayNumber = displayNumber + displayNumber
            }
        }
        showNumberOnLabel(number: displayNumber)
    }
    
    func showNumberOnLabel(number: Double) {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 9
        if abs(number) >= 1000000000 || abs(number) <=  0.000000001 && number != 0 {
            numberFormatter.numberStyle = NumberFormatter.Style.scientific
            numberFormatter.exponentSymbol = "e"
        } else {
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
        }
        
        if abs(number) > Double(10^160) {
            numberLabel.text = "Error"
        }
        
        numberLabel.text = numberFormatter.string(from: NSNumber(value: number))
    }
    
    
    
}


extension UIButton {
    
    enum buttonColor {
        case number
        case greyOperation
        case orangeOperation
    }
    
    
    func makeCircular() {
        self.layer.cornerRadius = self.bounds.size.height / 2.0
        self.clipsToBounds = true
    }
    
    func highlight(withTitleColor titleColor: UIColor, andBackgroundColor backgroundColor: UIColor) {
        UIView.transition(with: self, duration: 0.25, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            self.titleLabel?.textColor = titleColor
            self.backgroundColor = backgroundColor
        }, completion: nil)
        
    }
    
    func flash(withTitleColor titleColor: UIColor, andBackgroundColor backgroundColor: UIColor) {
        let originalTitleColor = self.titleLabel?.textColor
        let originalBackgroundColor = self.backgroundColor
        print("OriginalTC: \(originalTitleColor); OriginalBG: \(originalBackgroundColor)")
        
        UIView.transition(with: self, duration: 0.2, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            self.titleLabel?.textColor = titleColor
            self.backgroundColor = backgroundColor
        }, completion: { completed in
            if completed {
                UIView.transition(with: self, duration: 0.2, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                    self.titleLabel?.textColor = originalTitleColor
                    self.backgroundColor = originalBackgroundColor
                }, completion: nil)}
        })
    }
}

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



extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
