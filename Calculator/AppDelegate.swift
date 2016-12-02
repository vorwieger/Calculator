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
            let calculator = Calculator(input: source)
            calculator.scale = 15
            let locale = Locale(identifier: "de")
            outputField.textColor = NSColor.black
            outputField.stringValue = try calculator.calc()?.description(withLocale:locale) ?? ""
        } catch {
            outputField.textColor = NSColor.red
            outputField.stringValue = "\(error)"
        }
    }

}

