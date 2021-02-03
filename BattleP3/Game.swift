//
//  Game.swift
//  BattleP3
//
//  Created by Nicolas SERVAIS on 19/01/2021.
//

import Foundation

class Game {
    enum Status {
        case none, makeTeam, battle, finish
    }
    static var boardCharacters: [Character] = []
    static var boardWeapons: [Weapon] = []
    var statusGame: Status
    var teamActive: Team.Identifier
    var lastTeamWinner: Team.Identifier
    var teamA: Team
    var teamB: Team
    /// Description battle player TeamA
    var battlePlayerTeamA: Fighter
    var battlePlayerTeamB: Fighter
    private var loopAddWeapon: Bool
    private var loopAddName: Bool
    var boardNamesFighters: [String]
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
        fillCharacters()
        fillWeapons()
    }

// MARK: INITIALISATION
    private func fillCharacters() {
        let character: Character = BattleP3.Character(identifier: .bird)
        Game.boardCharacters = character.fillBoard()
        }
    private func fillWeapons() {
        let weapon: Weapon = Weapon(identifier: .none)
        Game.boardWeapons = weapon.fillBoard()
        }

// MARK: - PHASE
    func speedStart() {
        if teamA.getCount() < 3 && teamB.getCount() < 3 {

            teamA.addNewFighter(fighter: .init(id: .bird, name: "Nicolas", weapon: .init(identifier: .baton)))
            teamA.addNewFighter(fighter: .init(id: .chicken, name: "Michel", weapon: .init(identifier: .hammer)))
            teamA.addNewFighter(fighter: .init(id: .elephant, name: "Marc", weapon: .init(identifier: .chopped)))

            teamB.addNewFighter(fighter: .init(id: .camel, name: "Olivier", weapon: .init(identifier: .machete)))
            teamB.addNewFighter(fighter: .init(id: .rabbit, name: "Guillaume", weapon: .init(identifier: .needle)))
            teamB.addNewFighter(fighter: .init(id: .duck, name: "Neo", weapon: .init(identifier: .knife)))

        }
        // printCharactersFree()
        // printWeaponsFree()
        // printBattle()
        teamA.calculTeam()
        teamB.calculTeam()
        // printTeamWinner()
        print("\(whoTeamStarting()) commence")
//        teamActive = .TeamA
        statusGame = .battle
        startNewBattle()

    }
    func startMenu() {
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
    func startNewGame() {
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
    func startNewBattle() {
        print("La bataille peux commencer !!!")
        Display.printBattle(teamA: teamA, teamB: teamB)
        while (teamA.getGameLife() > 0 || teamB.getGameLife() > 0) && statusGame == .battle {
            var phrase: String = "L'\(teamA.getFrenchName(team: teamActive)) choisi un personnage : "
            phrase.append("\(printPlayerAlive(team: teamActive)) ?")
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
    func battle() {
        battlePlayerTeamA.setReady(ready: false)
        battlePlayerTeamB.setReady(ready: false)
            newBonus()
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
            if teamB.getGameLife() == 0 {
                Display.printBattle(teamA: teamA, teamB: teamB)
                setWinner(team: teamA)
                print(" ")
                print("L'équipe B a perdu")
                print(" ")
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
            if teamA.getGameLife() == 0 {
                Display.printBattle(teamA: teamA, teamB: teamB)
                setWinner(team: teamB)
                print(" ")
                print("L'équipe A a perdu")
                print(" ")
            }
        }
    }
    func setWinner(team: Team) {
        statusGame = .finish
        lastTeamWinner = team.getIdentifier()
        team.setWinner(team: team)
        teamA.setPlayersIsAlive()
        teamB.setPlayersIsAlive()
        teamA.calculTeam()
        teamB.calculTeam()
        Display.printTeamWinner(teamA: teamA, teamB: teamB)
        startMenu()
    }
    func resetBoards() {
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
    func newBonus() {
        var teamWinner: Team = .init(identifier: .none)
        let fighterWinner: Fighter
        if teamA.getGameLife() < teamB.getGameLife() {
            // if Int.random(in: 0...teamA.getGameLife()) == teamA.getGameLife() {
            if Int.random(in: 0...teamA.getGameLife()) == teamA.getGameLife() {
                teamWinner = teamA
                fighterWinner = teamWinner.getFighter(number: Int.random(in: 0...2))
                fighterWinner.addNewBonus()
            }
        } else if teamA.getGameLife() > teamB.getGameLife() {
            // if Int.random(in: 0...teamB.getGameLife()) == teamB.getGameLife() {
            if Int.random(in: 0...teamA.getGameLife()) == teamA.getGameLife() {
                    teamWinner = teamB
                fighterWinner = teamWinner.getFighter(number: Int.random(in: 0...2))
                fighterWinner.addNewBonus()
            }
        }
    }

// MARK: - MAKE TEAM
    func whoTeamStarting() -> String {
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
    func chooseTeams() -> Bool {
        while !teamA.isComplete() && !teamB.isComplete() {
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
    func chooseWeapon(fighter: Fighter) {
        loopAddWeapon = true
        while loopAddWeapon {
            printWeaponsFree()
            print("\(fighter.getName()) \(fighter.getFrenchName()) choisi une arme")
            if let numberWeapon = readLine() {
                print(parserWeapon(fighter: fighter, string: numberWeapon))
            } else {
                print("Je n'ai pas compris le choix de l'arme")
            }
        }
    }
    func chooseName() -> String {
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

// MARK: PARSER
    func parserMenu(string: String) {
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
                startMenu()
            } else {
                print(parserExit())
            }
        } else if string == "stat" {
            if statusGame == .none {
                print("Vous pouvez afficher les statistiques à n'importe quel moment")
                Display.printTeamWinner(teamA: teamA, teamB: teamB)
                startMenu()
            } else {
                Display.printTeamWinner(teamA: teamA, teamB: teamB)
            }
        } else if string == "reset" {
            if statusGame == .none {
                print("Vous pouvez réinitialiser le jeux à n'importe quel moment")
                startMenu()
            } else {
                print(parserInitStat())
            }
        } else if string == "speed"{
            // print("SpeedStart")
            speedStart()
        } else if statusGame == .none {
            startMenu()
        }
    }
    func parserCharacter(string: String) -> (String) {
        if string.count == 1 {
            if string == "0" || string == "1"  || string == "2" || string == "3" || string == "4" || string == "5"
                || string == "6" || string == "7" || string == "8" || string == "9" {
                if let number = Int(string) {
                    let fighter: Fighter = Fighter(id: Game.boardCharacters[number].getIdentifier())
                    fighter.setName(name: chooseName())
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
    func parserWeapon(fighter: Fighter, string: String) -> (String) {
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
                                    return teamA.printNewPlayerWithWeapon()
                                }
                            case .teamB:
                                if teamB.changeWeapon(fighter: fighter, weapon: Game.boardWeapons[number]) {
                                    Game.boardWeapons[number].setStatus(status: .notFree)
                                    loopAddWeapon = false
                                    return teamB.printNewPlayerWithWeapon()
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
    func parserBattle(string: String) -> (String) {
        if string.count == 1 {
            if string == "0" || string == "1"  || string == "2" {
                if let number = Int(string) {
                    switch teamActive {
                    case .none:
                        break
                    case .teamA:
                        if !battlePlayerTeamA.getReady() {
                            if !teamA.getPlayerIsDead(set: number) {
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
                            if !teamB.getPlayerIsDead(set: number) {
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
    func parserInitStat() -> (String) {
        print("Etes vous sur de vouloir initialiser les statistiques (O N) ?")
            if let string = readLine() {
                if string.count == 1 {
                    if string == "O" || string == "o" {
                        teamA.resetWin()
                        teamB.resetWin()
                        Display.printTeamWinner(teamA: teamA, teamB: teamB)
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
    func parserExit() -> (String) {
        print("Etes vous sur de vouloir Sortir (O N) ?")
        if let string = readLine() {
            if string.count == 1 {
                if string == "O" || string == "o" {
                    lastTeamWinner = teamActive
                    statusGame = .none
                    teamA.setPlayersIsAlive()
                    teamB.setPlayersIsAlive()
                    teamA.calculTeam()
                    teamB.calculTeam()
                    startMenu()
                    return ""
                } else if string == "N" || string == "n" {
                    return "La partie continue"
                }
            }
        }
        return "Je n'ai pas compris"
    }

// MARK: PRINT
    func printPlayerAlive(team: Team.Identifier) -> String {
        var phrase: String = ""
        var myTeam: Team = Team.init(identifier: .none)
        switch team {
        case .none:
            break
        case .teamA:
            myTeam = teamA
        case .teamB:
            myTeam = teamB
        }

        for position in 0...2 {
            if !myTeam.getPlayerIsDead(set: position) {
                phrase.append("\(position)")
                phrase.append(" ")
            }
        }
        return phrase
    }
    func printWeaponsFree() {
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
}

