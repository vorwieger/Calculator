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
    
    init(input: String) {
        self.input = input
    }
    
    public func calc() throws -> NSDecimalNumber? {
        let lexer = Lexer(input: input)
        let tokens = try lexer.tokenize()
        if tokens.count > 0 {
            let parser = Parser(tokens: tokens)
            let expr = try parser.parseExpression()
            return expr.result
        } else {
            return nil
        }
    }

        
}
