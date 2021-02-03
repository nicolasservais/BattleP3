//
//  Character.swift
//  BattleP3
//
//  Created by Nicolas SERVAIS on 15/01/2021.
//

import Foundation
class Character {
    enum Identifier:CaseIterable {
        case bird,chicken,duck,rabbit,ostrich,lion,horse,camel,elephant
    }
    enum Status {
        case free, notFree
    }
    private var identifier:Identifier
    private var life:Int // between 0...10 points
    private var speed:Int // between 0...10 points
    private var damage:Int // between 0...10 points
    private var status:Status
    init(identifier:Identifier) {
        self.identifier = identifier
        self.life = 0
        self.speed = 0
        self.damage = 0
        self.status = .free

        self.life = getLifeCharacter()
        self.speed = getSpeedCharacter()
        self.damage = getSpeedCharacter()
    }
//MARK: BOARD
    func fillBoard() -> [Character] {
        var board:[Character] = []
        for identifier in Character.Identifier.allCases {
            let character:Character = Character(identifier: identifier)
            board.append(character)
        }
        return board
    }
//MARK: GET SET
    func getIdentifier() -> Identifier {
        return identifier
    }
    func getLife() -> Int {
        return life
    }
    func getSpeed() -> Int {
        return speed
    }
    func getStatus() -> Status {
        return status
    }
    func setStatus(status:Status) {
        self.status = status
    }
    func getLifeCharacter() -> Int {
        switch identifier {
        case .bird:
            return 1
        case .chicken:
            return 2
        case .duck:
            return 3
        case .rabbit:
            return 4
        case .ostrich:
            return 5
        case .lion:
            return 6
        case .horse:
            return 7
        case .camel:
            return 8
        case .elephant:
            return 9
        }
    }
    func getSpeedCharacter() -> Int {
        switch identifier {
        case .bird:
            return 9
        case .chicken:
            return 8
        case .duck:
            return 7
        case .rabbit:
            return 6
        case .ostrich:
            return 5
        case .lion:
            return 4
        case .horse:
            return 3
        case .camel:
            return 2
        case .elephant:
            return 1
        }
    }
    func getDamageCharacter() -> Int {
        switch identifier {
        case .bird:
            return 1
        case .chicken:
            return 2
        case .duck:
            return 3
        case .rabbit:
            return 4
        case .ostrich:
            return 5
        case .lion:
            return 6
        case .horse:
            return 7
        case .camel:
            return 8
        case .elephant:
            return 9
        }
    }
    func getFrenchName() -> String {
        switch identifier {
        case .bird:
            return "l'Oiseau"
        case .chicken:
            return "le Poulet"
        case .duck:
            return "le Canard"
        case .rabbit:
            return "le Lapin"
        case .ostrich:
            return "l'Autruche"
        case .lion:
            return "le Lion"
        case .horse:
            return "le Cheval"
        case .camel:
            return "le Chameau"
        case .elephant:
            return "l'Elephant"
        }
    }
//MARK: PRINT

}
