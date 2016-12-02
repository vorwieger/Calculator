//
//  Lexer.swift
//  Calculator
//
//  Created by Peter Vorwieger on 01.12.16.
//  Copyright © 2016 Peter Vorwieger. All rights reserved.
//

import Foundation

public enum Token {
    case number(String)
    case parensOpen
    case parensClose
    case other(String)
}

typealias TokenGenerator = (String) -> Token?
let tokenList: [(String, TokenGenerator)] = [
    ("[ \t\n]", { _ in nil }),
    ("[0-9.]+", { r in .number(r) }),
    ("\\(", { _ in .parensOpen }),
    ("\\)", { _ in .parensClose })
]

public class Lexer {
    
    let input: String
    
    init(input: String) {
        self.input = input
    }
    
    public func tokenize() -> [Token] {
        var tokens = [Token]()
        var content = input
        
        while (content.characters.count > 0) {
            var matched = false
            
            for (pattern, generator) in tokenList {
                if let m = content.match(pattern) {
                    if let t = generator(m) {
                        tokens.append(t)
                    }
                    let offset = m.characters.count
                    let index = content.characters.index(content.startIndex, offsetBy: offset)
                    content = content.substring(from: index)
                    matched = true
                    break
                }
            }
            
            if !matched {
                let index = content.characters.index(content.startIndex, offsetBy: 1)
                tokens.append(.other(content.substring(to: index)))
                content = content.substring(from: index)
            }
        }
        return tokens
    }
    
}
