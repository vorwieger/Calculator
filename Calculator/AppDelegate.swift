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

        do {
            let lexer = Lexer(input: source)
            let tokens = try lexer.tokenize()
            //print(tokens)
            if tokens.count > 0 {
                let parser = Parser(tokens: tokens)
                let expr = try parser.parseExpression()
                print(expr)
                let behaviour = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.plain, scale: 15, raiseOnExactness: true, raiseOnOverflow: true, raiseOnUnderflow: true, raiseOnDivideByZero: true)
                outputField.stringValue = expr.result.rounding(accordingToBehavior: behaviour ).description
                print(expr.result.description)
            } else {
                outputField.stringValue = ""
            }
        } catch {
            outputField.stringValue = "\(error)"
        }
    }

}

