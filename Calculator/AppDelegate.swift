//
//  AppDelegate.swift
//  Calculator
//
//  Created by Peter Vorwieger on 27.11.16.
//  Copyright © 2016 Peter Vorwieger. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSTextFieldDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var inputField: NSTextField!
    @IBOutlet weak var outputField: NSTextField!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        inputField.delegate = self
    }

    override func controlTextDidChange(_ notification: Notification) {
        let textField = notification.object as! NSTextField
        let source = textField.stringValue.replacingOccurrences(of: ",", with: ".")
        
        let lexer = Lexer(input: source)
        let tokens = lexer.tokenize()
        //print(tokens)
        if tokens.count > 0 {
            let parser = Parser(tokens: tokens)
            do {
                let expr = try parser.parseExpression()
                print(expr)
                let behaviour = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.plain, scale: 15, raiseOnExactness: true, raiseOnOverflow: true, raiseOnUnderflow: true, raiseOnDivideByZero: true)
                outputField.stringValue = expr.result.rounding(accordingToBehavior: behaviour ).description
                print(expr.result.description)
            }
            catch {
                outputField.stringValue = "\(error)"
            }
        } else {
            outputField.stringValue = "";
        }
    }

}

