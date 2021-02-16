//
//  Team.swift
//  BattleP3
//
//  Created by Nicolas SERVAIS on 19/01/2021.
//

import Foundation

class Team {
    /// To play the game, two Team are fighting
    /// Each team are constituted with three fighter
    enum Identifier {
        case none,teamA,teamB
    }
    private var gameLife:Int
    private var identifier:Identifier
    private var boardFighters:[Fighter]
    private var counterWinner:Int
    init(identifier:Identifier) {
        self.counterWinner = 0
        self.gameLife = 0
        self.identifier = identifier
        boardFighters = []
    }
// MARK: GET SET
    func setIsFinish() {
        for fighter in boardFighters {
            fighter.setIsFinish()
        }
        calculTeam()
    }
    func resetBoard() {
        boardFighters.removeAll()
    }
    func resetWin() {
        counterWinner = 0
    }
    func isComplete() -> Bool {
        if boardFighters.count == 3 {
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
    func getFighterIsDead(set: Int) -> Bool {
        if set < boardFighters.count {
            return boardFighters[set].isDead()
        }
        return false
    }
    func getGameLifeWithCalcul() -> Int {
        calculTeam()
        if gameLife < 0 { gameLife = 0 }
        return gameLife
    }
    func getGameLife() -> Int {
        if gameLife < 0 { gameLife = 0 }
        return gameLife
    }
    func getFighter(number: Int) -> Fighter {
        if number <= boardFighters.count-1 {
            return boardFighters[number]
        }
        return Fighter.init(id: .bird)
    }
    func getCount() -> Int {
        return boardFighters.count
    }
    func getBoardFighters() -> [Fighter] {
        return boardFighters
    }
// MARK: 
    func addNewFighter(fighter: Fighter) {
        boardFighters.append(fighter)
    }
    func changeWeapon(fighter: Fighter, weapon: Weapon) -> Bool {
        for fighters in boardFighters {
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
        for fighter in boardFighters {
            fighter.calculFighter(fighter: fighter)
            gameLife += fighter.getLifeInTeamWithCalcul()
        }
    }
// MARK: PRINT
    func getFrenchName(team: Team.Identifier) -> String {
        switch team {
        case .none: return "None"
        case .teamA: return "Equipe A"
        case .teamB: return "Equipe B"
        }
    }
}
