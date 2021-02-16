//
//  Bonus.swift
//  BattleP3
//
//  Created by Nicolas SERVAIS on 02/02/2021.
//

import Foundation
/// Generate with random a Bonus who modify one characteristic of a fighter (life or damage or speed with a value between 1...4)
class Bonus {
    enum Identifier {
        case addLife,addSpeed,addDamage
    }
    private var identifier:Identifier = .addDamage
    private var value:Int = 0//between 1...4 points
    init() {
        self.identifier = newIdentifier()
        self.value = newValue()
    }
//MARK: - GET SET
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
//MARK: - METHOD
    /// Who fighter win newBonus
    static func newBonus(teamA:Team, teamB:Team) -> Team {
        var teamWinner: Team = .init(identifier: .none)
        let fighterWinner: Fighter
        if teamA.getGameLife() < teamB.getGameLife() {
            if teamA.getGameLife() > 0 {
                let difference: Int = teamB.getGameLife()-teamA.getGameLife()
                if difference > 3 {
                //if Int.random(in: 0...difference) >= teamA.getGameLife() {
                    teamWinner = teamA
                    fighterWinner = teamWinner.getFighter(number: Int.random(in: 0...2))
                    if !fighterWinner.isDead() {
                        fighterWinner.addNewBonus()
                    }
                }
            }
        } else if teamA.getGameLife() > teamB.getGameLife() {
            if teamB.getGameLife() > 0 {
                let difference: Int = teamA.getGameLife()-teamB.getGameLife()
                //if Int.random(in: 0...difference) >= teamB.getGameLife() {
                if difference > 3 {
                    teamWinner = teamB
                    fighterWinner = teamWinner.getFighter(number: Int.random(in: 0...2))
                    if !fighterWinner.isDead() {
                        fighterWinner.addNewBonus()
                    }
                }
            }
        }
    return teamWinner
    }
//MARK: - NEW
    private func newIdentifier() -> Identifier {
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
    private func newValue() -> Int {
             return Int.random(in: 1...4)
        }
}
