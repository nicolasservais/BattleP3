//
//  Display.swift
//  BattleP3
//
//  Created by Nicolas SERVAIS on 02/02/2021.
//

import Foundation
/// Print something.
struct Display {
//Work with Game
    static func printPlayerAlive(teamActive: Team.Identifier, teamA: Team, teamB: Team) -> String {
        var phrase: String = ""
        var myTeam: Team = Team.init(identifier: .none)
        switch teamActive {
        case .none:
            break
        case .teamA:
            myTeam = teamA
        case .teamB:
            myTeam = teamB
        }

        for position in 0...2 {
            if !myTeam.getFighterIsDead(set: position) {
                phrase.append("\(position)")
                phrase.append(" ")
            }
        }
        return phrase
    }
    static func printWeaponsFree() {
        if Game.boardWeapons.count > 0 {
            print("*****************************************")
            print("*\t\tNAME\t\t  Dégats  Vitesse\t*")
            print("*****************************************")
            for position in 0...Game.boardWeapons.count-1 {
                let weapon: Weapon = Game.boardWeapons[position]
                if weapon.getStatus() == .free {
                    let nameWeapon = weapon.getFrenchName()
                    let numberTab: Int = 3-Int(nameWeapon.count/4)
                    var phrase: String = "*  \(position) :\t\(nameWeapon)"
                    for _ in 0...numberTab {phrase.append("\t") }
                    phrase.append("\(weapon.getDamage())")
                    phrase.append("   \t\(weapon.getSpeed())\t\t*")
                    print(phrase)
                }
            }
            print("*****************************************")
        }
    }
    static func printCharactersFree() {
        if Game.boardCharacters.count > 0 {
            print("*****************************************")
            print("*\t\t\tNAME\t\tVie\t Vitesse\t*")
            print("*****************************************")
            for pos in 0...Game.boardCharacters.count-1 {
                let character: Character = Game.boardCharacters[pos]
                if character.getStatus() == .free {
                    let nameCharacter = character.getFrenchName()
                    let numberTab: Int = 3-Int(nameCharacter.count/4)
                    var phrase: String = "*  \(pos) :\t\(nameCharacter)"
                    for _ in 0...numberTab {phrase.append("\t") }
                    phrase.append("\(character.getLife())")
                    phrase.append("   \t\(character.getSpeed())\t\t*")
                    print(phrase)
                }
            }
            print("*****************************************")
        }
    }
    static func printBonus(teamA:Team, teamB:Team, positionFighter:Int) -> String {
        var phrase:String = ""
        let leftCount: Int = teamA.getFighter(number: positionFighter).getBonusBoard().count
        let rightCount: Int = teamB.getFighter(number: positionFighter).getBonusBoard().count
        let definitiveCount: Int = Int([leftCount,rightCount].max()!)
        for index in 0...definitiveCount-1 {
            if index != 0 {
                phrase.append("\n")
            }
            phrase.append("*")
            if teamA.getFighter(number: positionFighter).getBonusBoard().count >= index+1 {
                let bonus: Bonus = teamA.getFighter(number: positionFighter).getBonusBoard()[index]
                switch bonus.getIdentifier() {
                case .addSpeed:
                    phrase.append("\t\t\t\t\t\t\t\t\t\t\t🎁 🏃\t +\(bonus.getValue())\t\t\t\t*")
                case .addDamage:
                    phrase.append("\t\t\t\t\t\t\t\t\t\t\t🎁 🗡\t\t  +\(bonus.getValue())\t\t*")
                case .addLife:
                    phrase.append("\t\t\t\t\t\t\t\t\t\t\t🎁 ❤️\t\t\t   +\(bonus.getValue())\t*")
                }
            }else {
                phrase.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t")
            }
            if teamB.getFighter(number: positionFighter).getBonusBoard().count >= index+1 {
                let bonus: Bonus = teamB.getFighter(number: positionFighter).getBonusBoard()[index]
                switch bonus.getIdentifier() {
                case .addSpeed:
                    phrase.append("\t\t\t\t\t\t\t\t\t\t🎁 🏃 \t  +\(bonus.getValue())\t\t\t *")
                case .addDamage:
                    phrase.append("\t\t\t\t\t\t\t\t\t\t🎁 🗡 \t\t   +\(bonus.getValue())\t\t *")
                case .addLife:
                    phrase.append("\t\t\t\t\t\t\t\t\t\t🎁 ❤️ \t\t\t    +\(bonus.getValue())\t *")
                }
            }else {
                phrase.append("\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t *")
            }
        }
        
        return phrase
    }
    static func printBattle(teamA: Team, teamB: Team) {
        if teamA.isComplete() && teamB.isComplete() {
            print("**************************************************************************************************************************************")
            print("*\t\tEquipeA\t\t\t\t\t\t\t\t\t\t  🏃   🗡   ❤️  *\t\t\t\tEquipeB\t\t\t\t\t\t\t  🏃   🗡   ❤️  *")
            print("**************************************************************************************************************************************")
            for position in 0...2 {
                var nameLeft: String = "\(teamA.getFighter(number: position).getName()) "
                nameLeft.append("\(teamA.getFighter(number: position).getFrenchName())")
                nameLeft.append(" avec \(teamA.getFighter(number: position).getWeapon().getFrenchName())")
                var nameRight: String = "\(teamB.getFighter(number: position).getName()) "
                nameRight.append("\(teamB.getFighter(number: position).getFrenchName())")
                nameRight.append(" avec \(teamB.getFighter(number: position).getWeapon().getFrenchName())")
                let numberSpaceLeft: Int = 41-Int(nameLeft.count)
                let numberSpaceRight: Int = 43-Int(nameRight.count)
                var phrase: String = "*  \(position) :\t\(nameLeft)"
                for _ in 0...numberSpaceLeft {phrase.append(" ") }
                phrase.append("    \(teamA.getFighter(number: position).getSpeedInTeam())  ")
                phrase.append("  \(teamA.getFighter(number: position).getDamageInTeam())  ")
                phrase.append("  \(teamA.getFighter(number: position).getLifeInTeam())  ")
                phrase.append(" *")
                
                for _ in 0...numberSpaceRight {phrase.append(" ") }
                phrase.append(nameRight)
                phrase.append("      \(teamB.getFighter(number: position).getSpeedInTeam())  ")
                phrase.append("  \(teamB.getFighter(number: position).getDamageInTeam())  ")
                phrase.append("  \(teamB.getFighter(number: position).getLifeInTeam())  ")
                phrase.append(" *")
                print(phrase)
                if teamA.getFighter(number: position).isBonus() || teamB.getFighter(number: position).isBonus() {
                    print(self.printBonus(teamA:teamA, teamB:teamB, positionFighter:position))
                }
            }
            print("**************************************************************************************************************************************")
            print("*\t\t\t\t\t\t\t\t\(teamA.getGameLife())\t\t\t\t\t\t\t\t\t*\t\t\t\t\t\t\t\t\(teamB.getGameLife())\t\t\t\t\t\t\t\t *")
            print("**************************************************************************************************************************************")
        } else {
            print("Les équipes ne sont pas complètes. L'equipeA a \(teamA.getCount()) combattant(s). L'equipeB a \(teamB.getCount()) combattant(s).")
        }
    }
    static func printFight(battlePlayerTeamA: Fighter, battlePlayerTeamB: Fighter) {
        print(" ")
        print("******************************************************************************************************************")
        print("*\t\t\t\t\t\t\t\t\t\t\t\t🗡🗡🗡 FIGHT 🗡🗡🗡\t\t\t\t\t\t\t\t\t\t\t *")
        print("******************************************************************************************************************")
        print("*\t\t\t\t\(battlePlayerTeamA.getFrenchName())\t\t\t\t\t\t\t\tVS\t\t\t\t\t\t\t\t\(battlePlayerTeamB.getFrenchName())\t\t\t\t *")
        print("******************************************************************************************************************")
    }
    static func printTeamWinner(rounds: Int, teamA: Team, teamB: Team) {
        print("*****************************************")
        print("*\t\t\tStatistiques\t\t\t\t*")
        print("*****************************************")
        print("* Dernier combat en \(rounds) round(s) \t\t\t*")
        print("* EquipeA : \(teamA.getWinner()) 🏆 \t\t\t\t\t\t*")
        print("* EquipeB : \(teamB.getWinner()) 🏆 \t\t\t\t\t\t*")
        print("*****************************************")
    }
    static func printNewPlayerWithWeapon(boardFighters: [Fighter]) -> String {
        if boardFighters.count > 0 {
            var phrase: String = "\(boardFighters[boardFighters.count-1].getName())"
            phrase.append(" \(boardFighters[boardFighters.count-1].getFrenchName())")
            phrase.append(" est équipé avec \(boardFighters[boardFighters.count-1].getWeapon().getFrenchName())")
            return(phrase)
        } else {
            return "ERROR in Display.printNewPlayerWithWeapon"
        }
    }
    static func printNewBonus(fighter:Fighter, bonus:Bonus) {
        print("🎁")
        print("🎁 \(fighter.getName()) \(fighter.getFrenchName()) vient de gagner \(bonus.getValue()) point(s) \(bonus.getIdentifierName())")
        print("🎁")
        }
}
