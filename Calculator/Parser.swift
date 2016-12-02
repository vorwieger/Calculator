//
//  Parser.swift
//  Calculator
//
//  Created by Peter Vorwieger on 01.12.16.
//  Copyright © 2016 Peter Vorwieger. All rights reserved.
//

import Foundation

enum Errors: Error {
    case unexpectedToken
    case undefinedOperator(String)
    
    case expectedCharacter(Character)
    case expectedExpression
}

class Parser {

    let tokens: [Token]
    var index = 0

    init(tokens: [Token]) {
        self.tokens = tokens
    }

    func peekCurrentToken() throws -> Token {
        if index >= tokens.count {
            throw Errors.unexpectedToken
        }
        return tokens[index]
    }

    func popCurrentToken() throws -> Token {
        if index >= tokens.count {
            throw Errors.unexpectedToken
        }
        let token = tokens[index]
        index += 1
        return token
    }
    
    func parseNumber() throws -> ExprNode {
        guard case let Token.number(value) = try popCurrentToken() else {
            throw Errors.unexpectedToken
        }
        return NumberNode(value: value)
    }
    
    func parseExpression() throws -> ExprNode {
        let node = try parsePrimary()
        return try parseBinaryOp(node)
    }

    func parseParens() throws -> ExprNode {
        guard case Token.parensOpen = try popCurrentToken() else {
            throw Errors.expectedCharacter("(")
        }
        let exp = try parseExpression()
        guard case Token.parensClose = try popCurrentToken() else {
            throw Errors.expectedCharacter(")")
        }
        return exp
    }
    
    func parsePrimary() throws -> ExprNode {
        switch (try peekCurrentToken()) {
        case .number:
            return try parseNumber()
        case .parensOpen:
            return try parseParens()
        default:
            throw Errors.expectedExpression
        }
    }
    
    let operatorPrecedence: [String: Int] = [
        "+": 20,
        "-": 20,
        "*": 40,
        "/": 40
    ]

    func getCurrentTokenPrecedence() throws -> Int {
        guard index < tokens.count else {
            return -1
        }
        guard case let Token.other(op) = try peekCurrentToken() else {
            return -1
        }
        guard let precedence = operatorPrecedence[op] else {
            throw Errors.undefinedOperator(op)
        }
        return precedence
    }

    func parseBinaryOp(_ node: ExprNode, exprPrecedence: Int = 0) throws -> ExprNode {
        var lhs = node
        while true {
            let tokenPrecedence = try getCurrentTokenPrecedence()
            if tokenPrecedence < exprPrecedence {
                return lhs
            }
            guard case let Token.other(op) = try popCurrentToken() else {
                throw Errors.unexpectedToken
            }
            var rhs = try parsePrimary()
            let nextPrecedence = try getCurrentTokenPrecedence()
            if tokenPrecedence < nextPrecedence {
                rhs = try parseBinaryOp(rhs, exprPrecedence: tokenPrecedence+1)
            }
            lhs = BinaryOpNode(op: op, lhs: lhs, rhs: rhs)
        }
    }

}
