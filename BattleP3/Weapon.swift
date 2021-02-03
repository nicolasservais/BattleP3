//
//  Weapon.swift
//  BattleP3
//
//  Created by Nicolas SERVAIS on 18/01/2021.
//

import Foundation
class Weapon {
    enum Identifier:CaseIterable {
        case none,needle,baton,knife,hammer,machete,sword,chopped,mass
    }
    enum Status {
        case free, notFree
    }
    private var identifier:Identifier
    private var damage:Int //between 0...10 points
    private var speed:Int //between 0...10 points
    private var status:Status
    init(identifier:Identifier) {
        self.identifier = identifier
        self.damage = 0
        self.speed = 0
        self.status = .free
        self.damage = getDamageWeapon()
        self.speed = getSpeedWeapon()
    }
//MARK: BOARD
    func fillBoard() -> [Weapon] {
        var board:[Weapon] = []
        for identifier in Weapon.Identifier.allCases {
            let weapon:Weapon = Weapon(identifier: identifier)
            board.append(weapon)
        }
        return board
    }
//MARK: GET SET
    func getIdentifier() -> Identifier {
        return identifier
    }
    func getDamage() -> Int {
        return damage
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
    func getDamageWeapon() -> Int {
        switch identifier {
        case .none:
            return 1
        case .needle:
            return 2
        case .baton:
            return 3
        case .knife:
            return 4
        case .hammer:
            return 5
        case .machete:
            return 6
        case .sword:
            return 7
        case .chopped:
            return 8
        case .mass:
            return 9
        }
    }
    func getSpeedWeapon() -> Int {
        switch identifier {
        case .none:
            return 9
        case .needle:
            return 8
        case .baton:
            return 7
        case .knife:
            return 6
        case .hammer:
            return 5
        case .machete:
            return 4
        case .sword:
            return 3
        case .chopped:
            return 2
        case .mass:
            return 1
        }
    }
    func getFrenchName() -> String {
        switch identifier {
        case .none:
            return "Rien du tout"
        case .needle:
            return "l'Aiguille"
        case .baton:
            return "le Batton"
        case .knife:
            return "le Couteau"
        case .hammer:
            return "le Marteau"
        case .machete:
            return "la Machette"
        case .sword:
            return "l'Epée"
        case .chopped:
            return "la Hache"
        case .mass:
            return "la Masse"
        }
    }
}
