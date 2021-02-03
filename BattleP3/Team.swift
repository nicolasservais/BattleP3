//
//  Team.swift
//  BattleP3
//
//  Created by Nicolas SERVAIS on 19/01/2021.
//

import Foundation

class Team {
    enum Identifier {
        case none,teamA,teamB
    }
    private var gameLife:Int
    private var identifier:Identifier
    private var boardFighter:[Fighter]
    private var counterWinner:Int
    init(identifier:Identifier) {
        self.counterWinner = 0
        self.gameLife = 0
        self.identifier = identifier
        boardFighter = []
    }
// MARK: GET SET
    func resetBoard() {
        boardFighter.removeAll()
    }
    func resetWin() {
        counterWinner = 0
    }
    func isComplete() -> Bool {
        // print("isComplete")
        var counterPlayerFinished: Int = 0
        for fighter in boardFighter {
            if fighter.getWeapon().getIdentifier() != .none && boardFighter.count == 3 {
                counterPlayerFinished += 1
            }
        }
        if counterPlayerFinished == 3 {
            return true
        } else {
            return false
        }
    }
    func setWinner(team:Team) {
        counterWinner += 1
    }
    func getWinner() -> Int {
        return counterWinner
    }
    func getIdentifier() -> Identifier {
        return identifier
    }
    func setPlayersIsAlive() {
        for fighter in boardFighter {
            fighter.setDead(set:false)
        }
    }
    func getPlayerIsDead(set: Int) -> Bool {
        if set < boardFighter.count {
            return boardFighter[set].isDead()
        }
        return false
    }
    func getGameLife() -> Int {
        gameLife = 0
        for fighter in boardFighter {
            gameLife += fighter.getLifeInTeam()
        }
        if gameLife <= 0 {
            gameLife = 0
        }
        return gameLife
    }
    func getFighter(number: Int) -> Fighter {
        if number <= boardFighter.count-1 {
            return boardFighter[number]
        }
        return Fighter.init(id: .bird)
    }
    func getCount() -> Int {
        return boardFighter.count
    }
    func addNewName(name: String) {
    }
    func addNewFighter(fighter: Fighter) {
        boardFighter.append(fighter)
    }
    func changeWeapon(fighter: Fighter, weapon: Weapon) -> Bool {
        for fighters in boardFighter {
            if fighters.getIdentifier() == fighter.getIdentifier() {
                fighters.setWeapon(weapon: weapon)
            return true
            }
        }
        return false
    }
// MARK: CALCUL
    func calculTeam() {
        gameLife = 0
        for fighter in boardFighter {
            fighter.calculFighter(fighter: fighter)
            gameLife += fighter.getLifeInTeam()
        }
    }
// MARK: PRINT
    func printNewPlayerWithWeapon() -> String {
        if boardFighter.count > 0 {
            var phrase: String = "\(boardFighter[boardFighter.count-1].getName())"
            phrase.append("\(boardFighter[boardFighter.count-1].getFrenchName())")
            phrase.append(" est équipé avec \(boardFighter[boardFighter.count-1].getWeapon().getFrenchName())")
            return(phrase)
        } else {
            return "ERROR in Team.printNewPlayer"
        }
    }
    func getFrenchName(team: Team.Identifier) -> String {
        switch team {
        case .none: return "None"
        case .teamA: return "Equipe A"
        case .teamB: return "Equipe B"
        }
    }
}
