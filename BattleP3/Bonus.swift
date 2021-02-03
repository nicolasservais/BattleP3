//
//  Bonus.swift
//  BattleP3
//
//  Created by Nicolas SERVAIS on 02/02/2021.
//

import Foundation

class Bonus {
    enum Identifier {
        case addLife,addSpeed,addDamage
    }
    private var identifier:Identifier = .addDamage
    private var value:Int = 0//between 1...9 points
    init() {
        self.identifier = newIdentifier()
        self.value = newValue()
        
    }
//MARK: NEW
    func newIdentifier() -> Identifier {
        switch Int.random(in: 0...2) {
        case 0:
            return .addDamage
        case 1:
            return .addLife
        case 2:
            return .addSpeed
        default:
            return .addLife
        }
    }
    func newValue() -> Int {
         return Int.random(in: 1...9)
    }
//MARK: GET SET
    func getIdentifier() -> Identifier {
        return identifier
    }
    func getValue() -> Int {
        return value
    }
    func getIdentifierName() -> String {
        switch identifier {
        case .addLife:
            return "de vie"
        case .addSpeed:
            return "de rapidité"
        case .addDamage:
            return "de force"
        }
    }
}
