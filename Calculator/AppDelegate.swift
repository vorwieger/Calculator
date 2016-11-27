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
        outputField.stringValue = textField.stringValue
    }

}

