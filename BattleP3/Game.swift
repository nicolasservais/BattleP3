//
//  Game.swift
//  BattleP3
//
//  Created by Nicolas SERVAIS on 19/01/2021.
//

import Foundation

final class Game {
    enum Status {
        case none, makeTeam, battle, finish
    }
    /// An array who stored all the characters of the game.
    /// When a character is choosen by a team is not available for the other Team.
    static var boardCharacters: [Character] = []
    /// An array who stored all the weapons of the game.
    /// When a weapon is used, is not available for other fighter.
    static var boardWeapons: [Weapon] = []
    /// The two team who are fighting.
    private var teamA: Team
    private var teamB: Team
    /// Stored the different phase of the game.
    private var statusGame: Status
    private var teamActive: Team.Identifier
    private var lastTeamWinner: Team.Identifier
    /// When the battle starting, the two battlePlayer are fighting.
    private var battlePlayerTeamA: Fighter
    private var battlePlayerTeamB: Fighter
    private var loopAddWeapon: Bool
    private var loopAddName: Bool
    /// An array who stored all the names to control that not duplicate.
    private var boardNamesFighters: [String]
    private var round: Int
    init() {
        Game.boardCharacters = []
        Game.boardWeapons = []
        statusGame = .none
        teamActive = .none
        lastTeamWinner = .none
        loopAddWeapon = false
        loopAddName = false
        boardNamesFighters = []
        teamA = Team.init(identifier: .teamA)
        teamB = Team.init(identifier: .teamB)
        battlePlayerTeamA = Fighter(id: .bird)
        battlePlayerTeamB = Fighter(id: .bird)
        round = 0
        fillCharacters()
        fillWeapons()
    }

// MARK: - INITIALISATION
    private func fillCharacters() {
        let character: Character = BattleP3.Character(identifier: .bird)
        Game.boardCharacters = character.fillBoard()
        }
    private func fillWeapons() {
        let weapon: Weapon = Weapon(identifier: .none)
        Game.boardWeapons = weapon.fillBoard()
        }
    private func resetBoards() {
        for character in Game.boardCharacters {
            character.setStatus(status: .free)
        }
        for weapon in Game.boardWeapons {
            weapon.setStatus(status: .free)
        }
        boardNamesFighters.removeAll()
        teamA.resetBoard()
        teamB.resetBoard()
    }
// MARK: - PHASE
    private func speedStart() {
        if teamA.getCount() < 3 && teamB.getCount() < 3 {
            teamA.addNewFighter(fighter: .init(id: .bird, name: "Nicolas", weapon: .init(identifier: .baton)))
            teamA.addNewFighter(fighter: .init(id: .chicken, name: "Michel", weapon: .init(identifier: .hammer)))
            teamA.addNewFighter(fighter: .init(id: .elephant, name: "Marc", weapon: .init(identifier: .chopped)))
            teamB.addNewFighter(fighter: .init(id: .camel, name: "Olivier", weapon: .init(identifier: .machete)))
            teamB.addNewFighter(fighter: .init(id: .rabbit, name: "Guillaume", weapon: .init(identifier: .needle)))
            teamB.addNewFighter(fighter: .init(id: .duck, name: "Neo", weapon: .init(identifier: .knife)))
        }
       // teamA.getFighter(number: 0).addNewBonus()
/*        teamA.getFighter(number: 0).addNewBonus()
        teamB.getFighter(number: 0).addNewBonus()
        teamA.getFighter(number: 1).addNewBonus()
        teamB.getFighter(number: 0).addNewBonus()
        teamB.getFighter(number: 1).addNewBonus()
        teamA.getFighter(number: 0).addNewBonus()
        teamB.getFighter(number: 0).addNewBonus()
        teamA.getFighter(number: 2).addNewBonus()
        teamA.getFighter(number: 2).addNewBonus()
*/        // printCharactersFree()
        // printWeaponsFree()
        // printBattle()
        teamA.calculTeam()
        teamB.calculTeam()
        // printTeamWinner()
        print("\(whoTeamStarting()) commence")
        statusGame = .battle
        startNewBattle()
    }
    func menu() {
    statusGame = .none
    print(" ")
    print("Que voulez vous faire ?")
    print(" ")
    if lastTeamWinner != .none && teamA.getCount() == 3 && teamB.getCount() == 3 {
        print("play  : Rejouer la partie avec les mêmes équipes")
    }
    print("start : Nouvelle Partie")
    print("equip : Voir les équipes")
    print("stat  : Voir les statistiques")
    print("reset : Initialise les statistiques")
    print("exit  : Quitter")
    if let string = readLine() {
        parserMenu(string: string)
    }
}
    private func startNewGame() {
        round = 0
        print("Deux équipes (A et B) chacune composé de trois personnages vont se livrer un combat")
        print(" ")
        print("L'\(whoTeamStarting()) commence")
        print(" ")
        statusGame = .makeTeam
        if chooseTeams() {
            statusGame = .battle
            startNewBattle()
        }
    }
    private func startNewBattle() {
        print("La bataille peux commencer !!!")
        Display.printBattle(teamA: teamA, teamB: teamB)
        while (teamA.getGameLifeWithCalcul() > 0 || teamB.getGameLifeWithCalcul() > 0) && statusGame == .battle {
            var phrase: String = "L'\(teamA.getFrenchName(team: teamActive)) choisi un personnage : "
            phrase.append("\(Display.printPlayerAlive(teamActive: teamActive, teamA:teamA, teamB:teamB)) ?")
            print(phrase)
            if let numberCharacter = readLine() {
                print(parserBattle(string: numberCharacter))
            } else {
                print("Je n'ai pas compris le choix du personnage")
            }
            if battlePlayerTeamA.getReady() && battlePlayerTeamB.getReady() {
                battle()
            }
        }
    }
    private func battle() {
        round += 1
        battlePlayerTeamA.setReady(ready: false)
        battlePlayerTeamB.setReady(ready: false)
        if Bonus.newBonus(teamA: teamA, teamB: teamB).getIdentifier() != .none {
            teamA.calculTeam()
            teamB.calculTeam()
            Display.printBattle(teamA: teamA, teamB: teamB)
        }
        
        let choose: Int = Int.random(in: 0...battlePlayerTeamA.getSpeedInTeam()+battlePlayerTeamB.getSpeedInTeam())
        if choose <= battlePlayerTeamA.getSpeedInTeam() {
            Display.printFight(battlePlayerTeamA: battlePlayerTeamA, battlePlayerTeamB: battlePlayerTeamB)
            print(" ")
            print(battlePlayerTeamB.getFrenchName(), " perd ", battlePlayerTeamA.getDamageInTeam(), "point(s) de vie")
            print(" ")

            if battlePlayerTeamB.setDecreaseLife(set: battlePlayerTeamA.getDamageInTeam()) {
                Display.printBattle(teamA: teamA, teamB: teamB)
                print(" ")
                print(battlePlayerTeamB.getFrenchName(), " est mort !")
                print(" ")
            }
            if teamB.getGameLifeWithCalcul() == 0 {
                Display.printBattle(teamA: teamA, teamB: teamB)
                print(" ")
                print("L'équipe B a perdu")
                print(" ")
                setWinner(team: teamA)
            }
        } else {
            Display.printFight(battlePlayerTeamA: battlePlayerTeamA, battlePlayerTeamB: battlePlayerTeamB)
            print(" ")
            print(battlePlayerTeamA.getFrenchName(), " perd ", battlePlayerTeamB.getDamageInTeam(), "point(s) de vie")
            print(" ")

            if battlePlayerTeamA.setDecreaseLife(set: battlePlayerTeamB.getDamageInTeam()) {
                Display.printBattle(teamA: teamA, teamB: teamB)
                print(" ")
                print(battlePlayerTeamA.getFrenchName(), " est mort !")
                print(" ")
            }
            if teamA.getGameLifeWithCalcul() == 0 {
                Display.printBattle(teamA: teamA, teamB: teamB)
                print(" ")
                print("L'équipe A a perdu")
                print(" ")
                setWinner(team: teamB)
            }
        }
    }
    private func setWinner(team: Team) {
        statusGame = .finish
        lastTeamWinner = team.getIdentifier()
        team.setWinner(team: team)
        teamA.setIsFinish()
        teamB.setIsFinish()
        Display.printTeamWinner(rounds:round, teamA: teamA, teamB: teamB)
        statusGame = .none
        menu()
    }
// MARK: - MAKE TEAM
    private func whoTeamStarting() -> String {
        switch lastTeamWinner {
        case .none:
            if Bool.random() {
                teamActive = .teamA
            } else {
                teamActive = .teamB
            }
        case .teamA:
            teamActive = .teamB
        case .teamB:
            teamActive = .teamA
        }
        return teamA.getFrenchName(team: teamActive)
    }
    private func chooseTeams() -> Bool {
        while teamA.getCount() < 3 && teamB.getCount() < 3 {
            Display.printCharactersFree()
            // printCharactersFree()
            print("\(teamA.getFrenchName(team: teamActive)) choisi un personnage")
            if let numberCharacter = readLine() {
                print(" ")
                print(parserCharacter(string: numberCharacter))
                print(" ")
            } else {
                print("Je n'ai pas compris le choix du personnage")
            }
        }
        teamA.calculTeam()
        teamB.calculTeam()
        return true
    }
    private func chooseWeapon(fighter: Fighter) {
        loopAddWeapon = true
        while loopAddWeapon {
            Display.printWeaponsFree()
            print("\(fighter.getName()) \(fighter.getFrenchName()) choisi une arme")
            if let numberWeapon = readLine() {
                print(parserWeapon(fighter: fighter, string: numberWeapon))
            } else {
                print("Je n'ai pas compris le choix de l'arme")
            }
        }
    }
    private func chooseNameFighter() -> String {
        loopAddName = true
        while loopAddName {
            var nameDuplicate: Bool = false
            print("Choisi un nom pour ce personnage :")
            if let newName = readLine() {
                if newName != "" {
                    for name in boardNamesFighters {
                    if name.lowercased() == newName.lowercased() {
                        print("Ce nom existe déjà.")
                    nameDuplicate = true
                    }
                }
                    if !nameDuplicate {
                        boardNamesFighters.append(newName)
                        loopAddName = false
                        return newName
                    }
                }
            } else {
                print("Je n'ai pas compris.")
            }
        }
        return "ERROR"
    }
// MARK: - PARSER
    private func parserMenu(string: String) {
        if string == "start" {
            if statusGame == .none {
                resetBoards()
                statusGame = .makeTeam
                startNewGame()
            } else {
                print("Une partie est déjà en cours, vous pouvez sortir avec exit")
            }
        } else if string == "equip" {
            Display.printBattle(teamA: teamA, teamB: teamB)
            if statusGame == .none || statusGame == .finish{
                menu()
            }
        } else if string == "play" {
            if teamA.isComplete() && teamB.isComplete() {
                statusGame = .battle
                startNewBattle()
            } else {
                print("Les équipes ne sont pas aux complet")
                var phrase: String = "Problème avec les équipes. L'equipeA a \(teamA.getCount()) personnage(s)."
                phrase.append(" L'equipeB a \(teamB.getCount()) personnage(s).")
                print(phrase)
                statusGame = .makeTeam
                startNewGame()
            }
        } else if string == "exit" {
            if statusGame == .none {
                print("Vous pouvez sortir du jeu à n'importe quel moment")
                menu()
            } else {
                print(parserExit())
            }
        } else if string == "stat" {
            if statusGame == .none {
                print("Vous pouvez afficher les statistiques à n'importe quel moment")
                Display.printTeamWinner(rounds:round, teamA: teamA, teamB: teamB)
                menu()
            } else {
                Display.printTeamWinner(rounds:round, teamA: teamA, teamB: teamB)
            }
        } else if string == "reset" {
            if statusGame == .none {
                print("Vous pouvez réinitialiser le jeux à n'importe quel moment")
                menu()
            } else {
                print(parserInitStat())
            }
        } else if string == "speed"{
            // print("SpeedStart")
            speedStart()
        } else if statusGame == .none {
            menu()
        }
    }
    private func parserCharacter(string: String) -> (String) {
        if string.count == 1 {
            if string == "0" || string == "1"  || string == "2" || string == "3" || string == "4" || string == "5"
                || string == "6" || string == "7" || string == "8" || string == "9" {
                if let number = Int(string) {
                    let fighter: Fighter = Fighter(id: Game.boardCharacters[number].getIdentifier())
                    fighter.setName(name: chooseNameFighter())
                    switch teamActive {
                    case .none:
                        break
                    case .teamA:
                        if Game.boardCharacters[number].getStatus() == .free {
                            Game.boardCharacters[number].setStatus(status: .notFree)
                            teamA.addNewFighter(fighter: fighter)
                            chooseWeapon(fighter: fighter)
                            teamActive = .teamB
                        } else {
                            return "\(Game.boardCharacters[number].getFrenchName()) n'est pas disponible)"
                        }
                    case .teamB:
                        if Game.boardCharacters[number].getStatus() == .free {
                            Game.boardCharacters[number].setStatus(status: .notFree)
                            teamB.addNewFighter(fighter: fighter)
                            chooseWeapon(fighter: fighter)
                            teamActive = .teamA
                        } else {
                            return "\(Game.boardCharacters[number].getFrenchName()) n'est pas disponible)"
                        }
                    }
                    return "\(fighter.getName()) \(fighter.getFrenchName()) vient d'intégrer l'\(teamA.getFrenchName(team: teamActive))"
                }
            }
        } else {
            parserMenu(string: string)
            return""
        }
        return "ERREUR"
    }
    private func parserWeapon(fighter: Fighter, string: String) -> (String) {
        if string.count == 1 {
            if string == "0" || string == "1"  || string == "2" || string == "3" || string == "4" || string == "5"
                || string == "6" || string == "7" || string == "8" || string == "9" {
                if let number = Int(string) {
                    if Game.boardWeapons[number].getStatus() == .free {
                        Game.boardWeapons[number].setStatus(status: .notFree)
                            switch teamActive {
                            case .none:
                                break
                            case .teamA:
                                if teamA.changeWeapon(fighter: fighter, weapon: Game.boardWeapons[number]) {
                                    Game.boardWeapons[number].setStatus(status: .notFree)
                                    loopAddWeapon = false
                                    return Display.printNewPlayerWithWeapon(boardFighters: teamA.getBoardFighters())
                                }
                            case .teamB:
                                if teamB.changeWeapon(fighter: fighter, weapon: Game.boardWeapons[number]) {
                                    Game.boardWeapons[number].setStatus(status: .notFree)
                                    loopAddWeapon = false
                                    return Display.printNewPlayerWithWeapon(boardFighters: teamB.getBoardFighters())
                                }
                            }
                        } else {
                            return "\(Game.boardWeapons[number].getFrenchName()) n'est pas disponible)"
                        }
                }
            }
        } else {
            parserMenu(string: string)
            return""
        }
        return "ERROR in parserWeapon"
    }
    private func parserBattle(string: String) -> (String) {
        if string.count == 1 {
            if string == "0" || string == "1"  || string == "2" {
                if let number = Int(string) {
                    switch teamActive {
                    case .none:
                        break
                    case .teamA:
                        if !battlePlayerTeamA.getReady() {
                            if !teamA.getFighterIsDead(set: number) {
                                teamActive = .teamB
                                battlePlayerTeamA = teamA.getFighter(number: number)
                                battlePlayerTeamA.setReady(ready: true)
                                var phrase: String = "L'\(teamA.getFrenchName(team: .teamA)) vient de choisir "
                                phrase.append("\(battlePlayerTeamA.getFrenchName())")
                                return phrase
                            } else {
                                return " \(teamA.getFighter(number: number).getFrenchName()) est déja mort ! "
                            }
                        }
                    case .teamB:
                        if !battlePlayerTeamB.getReady() {
                            if !teamB.getFighterIsDead(set: number) {
                                teamActive = .teamA
                                battlePlayerTeamB = teamB.getFighter(number: number)
                                battlePlayerTeamB.setReady(ready: true)
                                var phrase: String = "L'\(teamB.getFrenchName(team: .teamA)) vient de choisir "
                                phrase.append("\(battlePlayerTeamB.getFrenchName())")
                                return phrase
                        } else {
                            return " \(teamB.getFighter(number: number).getFrenchName()) est déja mort ! "
                        }
                        }
                    }
                }
            }
        } else {
            parserMenu(string: string)
            return ""
        }
        return "Je n'ai pas compris"
    }
    private func parserInitStat() -> (String) {
        print("Etes vous sur de vouloir initialiser les statistiques (O N) ?")
            if let string = readLine() {
                if string.count == 1 {
                    if string == "O" || string == "o" {
                        teamA.resetWin()
                        teamB.resetWin()
                        Display.printTeamWinner(rounds:round, teamA: teamA, teamB: teamB)
                        return "Initialisation terminée"
                    } else if string == "N" || string == "n" {
                        return "Pas d'initialisation"
                    }
            } else {
                return("Je n'ai pas compris, action annulée")
            }
        }
        return "Je n'ai pas compris"
    }
    private func parserExit() -> (String) {
        print("Etes vous sur de vouloir Sortir (O N) ?")
        if let string = readLine() {
            if string.count == 1 {
                if string == "O" || string == "o" {
                    lastTeamWinner = teamActive
                    statusGame = .none
                    teamA.setIsFinish()
                    teamB.setIsFinish()
                    menu()
                    return ""
                } else if string == "N" || string == "n" {
                    return "La partie continue"
                }
            }
        }
        return "Je n'ai pas compris"
    }
}

