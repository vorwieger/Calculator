//
//  Calculator.swift
//  Calculator
//
//  Created by Peter Vorwieger on 02.12.16.
//  Copyright © 2016 Peter Vorwieger. All rights reserved.
//

import Foundation

public class Calculator {
    
    let input: String
    var scale = 15
    
    init(input: String) {
        self.input = input
    }
    
    public func calc() throws -> NSDecimalNumber? {
        let lexer = Lexer(input: input)
        let tokens = try lexer.tokenize()
        if tokens.count > 0 {
            let parser = Parser(tokens: tokens)
            let expr = try parser.parseExpression()
            let behaviour = NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.plain, scale: Int16(self.scale), raiseOnExactness: true, raiseOnOverflow: true, raiseOnUnderflow: true, raiseOnDivideByZero: true)
            return expr.result.rounding(accordingToBehavior: behaviour)
        } else {
            return nil
        }
    }

        
}
