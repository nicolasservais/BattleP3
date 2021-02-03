//
//  Display.swift
//  BattleP3
//
//  Created by Nicolas SERVAIS on 02/02/2021.
//

import Foundation
struct Display {
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
    static func printBattle(teamA: Team, teamB: Team) {
        if teamA.getCount() == 3 && teamB.getCount() == 3 {
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
            }
            print("**************************************************************************************************************************************")
            print("*\t\t\t\t\t\t\t\t\(teamA.getGameLife())\t\t\t\t\t\t\t\t\t**\t\t\t\t\t\t\t\t\(teamB.getGameLife())\t\t\t\t\t\t\t\t *")
            print("**************************************************************************************************************************************")
        } else {
            print("Les équipes ne sont pas complètes. L'equipeA a \(teamA.getCount()) combattant(s). L'equipeB a \(teamB.getCount()) combattant(s).")
            // startMenu()
            // statusGame = .MakeTeam
            // rstartNewGame()
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
    static func printTeamWinner(teamA: Team, teamB: Team) {
        print("*****************************************")
        print("*\t\t\tStatistiques\t\t\t\t*")
        print("*****************************************")
        print("* EquipeA : \(teamA.getWinner()) 🏆 \t\t\t\t\t\t*")
        print("* EquipeB : \(teamB.getWinner()) 🏆 \t\t\t\t\t\t*")
        print("*****************************************")
    }

}
