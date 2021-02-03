//
//  Player.swift
//  BattleP3
//
//  Created by Nicolas SERVAIS on 25/01/2021.
//

import Foundation

class Fighter:Character {
    private var lifeInTeam:Int
    private var speedInTeam:Int
    private var damageInTeam:Int
    private var ready:Bool
    private var dead:Bool
    private var name:String
    private var weapon:Weapon
    private var boardBonus:[Bonus]

    init(id:Character.Identifier) {
        self.dead = false
        self.lifeInTeam = 0
        self.speedInTeam = 0
        self.damageInTeam = 0
        self.ready = false
        self.name = "ERROR"
        self.weapon = Weapon(identifier: .none)
        self.boardBonus = []
        super.init(identifier: id)
    }
    init(id:Character.Identifier, name:String, weapon:Weapon) {
        self.dead = false
        self.lifeInTeam = 0
        self.speedInTeam = 0
        self.damageInTeam = 0
        self.ready = false
        self.name = name
        self.weapon = weapon
        self.boardBonus = []
        super.init(identifier: id)

    }
//MARK: BONUS
    func addNewBonus() {
        let bonus:Bonus = .init()
        printBonus(bonus: bonus)
        boardBonus.append(bonus)
    }
    func cleanBonus() {
        boardBonus.removeAll()
    }
//MARK: GET SET
    func getWeapon() -> Weapon {
        return weapon
    }
    func setWeapon(weapon:Weapon) {
        self.weapon = weapon
    }

    func getName() -> String {
        return self.name
    }
    func setName(name:String) {
        self.name = name
    }
    func setDead(set:Bool) {
        dead = set
    }
    func isDead() -> Bool {
        return dead
    }
    func setDecreaseLife(set: Int) -> Bool {
        lifeInTeam -= set
        if lifeInTeam <= 0 {
            dead = true
            lifeInTeam = 0
            return true
        }
        return false
    }
    func setReady(ready:Bool) {
        self.ready = ready
    }
    func getReady() -> Bool{
        return ready
    }
    func getLifeInTeam () -> Int {
        return lifeInTeam
    }
    func getSpeedInTeam () -> Int {
        return speedInTeam
    }
    func getDamageInTeam () -> Int {
        return damageInTeam
    }
//MARK: CALCUL
    func calculFighter(fighter:Fighter) {
        var addLife:Int = 0
        var addDamage:Int = 0
        var addSpeed:Int = 0
        for bonus in boardBonus {
            switch bonus.getIdentifier() {
            case .addLife:
                addLife += bonus.getValue()
            case .addSpeed:
                addSpeed += bonus.getValue()
            case .addDamage:
                addDamage += bonus.getValue()
            }
        }
        
        fighter.lifeInTeam = fighter.getLifeCharacter()+addLife
        fighter.damageInTeam = Int((fighter.getWeapon().getDamage()+fighter.getDamageCharacter())/2)+addDamage
        fighter.speedInTeam = Int((fighter.getSpeedCharacter()+fighter.getWeapon().getSpeedWeapon())/2)+addSpeed
        
        if fighter.lifeInTeam > 9 { fighter.lifeInTeam = 9 }
        if fighter.damageInTeam > 9 { fighter.damageInTeam = 9 }
        if fighter.speedInTeam > 9 { fighter.speedInTeam = 9 }
    }
//MARK: PRINT
    func printBonus(bonus:Bonus) {
        print("###################################################################################################")
        print("\(self.getName()) \(self.getFrenchName()) vient de gagner \(bonus.getValue()) point(s) \(bonus.getIdentifier())")
        print("###################################################################################################")
        }
}
