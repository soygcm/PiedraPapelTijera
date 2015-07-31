//
//  FirstMatchController.swift
//  PiedraPapelTijera
//
//  Created by Gabriel Castañaza on 29/7/15.
//  Copyright (c) 2015 Ministerio de Salud. All rights reserved.
//

import UIKit
import CoreData

class MatchesController: UITableViewController {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var mainController: MainController!
    
    var players = [Player]()
    var matches: [Match]{
        
        if round == Tournament.firstMatch {
            
            matchesFirstMatch.sort({ $0.start.compare($1.start) == NSComparisonResult.OrderedAscending })
            
            return matchesFirstMatch
        }
        if round == Tournament.quarterFinals {
            
            matchesQuarters.sort({ $0.start.compare($1.start) == NSComparisonResult.OrderedAscending })
            
            return matchesQuarters
        }
        if round == Tournament.semiFinals {
            
            matchesSemiFinal.sort({ $0.start.compare($1.start) == NSComparisonResult.OrderedAscending })
            
            return matchesSemiFinal
        }
        if round == Tournament.finals {
            
            matchesFinal.sort({ $0.start.compare($1.start) == NSComparisonResult.OrderedAscending })
            
            return matchesFinal
        }
        
        return [Match]()
        
    }
    var matchesFirstMatch = [Match]()
    var matchesQuarters = [Match]()
    var matchesSemiFinal = [Match]()
    var matchesFinal = [Match]()
    
    var tournament: Tournament!
    
    var round = ""
    
    let idMatchCell = "matchCell"
    
    var finalCount = 0
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUI()
        
        if round != ""{
            getMatches()
        }
        
        getPlayers()
        
    }
    
    // MARK: - UI
    
    func setUI(){
        setTitle()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.backgroundColor = UIColor.clearColor()
        self.view.backgroundColor = Colors.background
        
        self.tableView.registerClass(MatchCell.classForCoder(), forCellReuseIdentifier: idMatchCell)
        
        if round == Tournament.firstMatch || round == ""{
            
            var closeButton = UIBarButtonItem(title: "regresar", style: UIBarButtonItemStyle.Plain, target: self, action: "dismiss")
            
            navigationItem.leftBarButtonItem = closeButton
            
        }
        
    }
    
    func dismiss(){
    
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    
    func setTitle(){
        title = "Primer Encuentro"
        if round == Tournament.quarterFinals{
            title = "Cuartos de Final"
        }
        if round == Tournament.semiFinals{
            title = "Semifinales"
        }
        if round == Tournament.finals{
            title = "Finales"
        }
    }
    
    func addNextButton(){
        
        var next = UIBarButtonItem(title: "siguiente", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("next"))
        
        self.navigationItem.setRightBarButtonItem(next, animated: true)
        
    }
    
    func animMove(){
        if let lastCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: matches.count-1, inSection: 0)) as? MatchCell{
            lastCell.moveA.animAppear()
            lastCell.moveB.animAppear()
        }
        
        
        
    }
    
    // MARK: - Data
    
    func save() {
        var error : NSError?
        if( !managedObjectContext!.save(&error) ) {
            println(error?.localizedDescription)
        }
    }
    
    func getMatches(){
        
        let req = NSFetchRequest(entityName: "Tournament")
        var sortDescriptor = NSSortDescriptor(key: "start", ascending: false)
        req.sortDescriptors = [sortDescriptor]
        req.fetchLimit = 1
        if let results = managedObjectContext!.executeFetchRequest(req, error: nil) as? [Tournament] {
            
            if results.count > 0{
                
                self.tournament = results.first!
                
                self.matchesFirstMatch = self.tournament.firstMatch.allObjects as! [Match]

                self.matchesQuarters = self.tournament.quarterFinals.allObjects as! [Match]

                self.matchesSemiFinal = self.tournament.semiFinals.allObjects as! [Match]

                self.matchesFinal = self.tournament.finals.allObjects as! [Match]
                
                
                for match in self.matches{
                    match.fillMovesArray()
                }
                
                tableView.reloadData()
                
            }
            
            
        }
        
        
    }
    
    func getInitialPlayers(){
        
        let req = NSFetchRequest(entityName: "Player")
        
        if let results = managedObjectContext!.executeFetchRequest(req, error: nil) as? [Player] {
            
            if results.count > 0{
                
                if results.count == 24{
                    
                    players = results
                    
                }
                
            }
            
        }
        
    }
    
    // MARK: - Logic Game
    
    func getFirstMatchWinnersPlayers(){
        
        for match in matchesFirstMatch{
            
            players.append(match.winner)
            
        }
        
    }
    
    func getSemiFinalsWinnersPlayers(){
        
        for match in matchesSemiFinal{
            
            players.append(match.winner)
            
        }
        
    }
    
    func getQuarterFinalsWinnersPlayers(){
        
        for match in matchesQuarters{
            
            players.append(match.winner)
            
        }
        
    }

    
    func removePlayersPlayed(){
        
        for match in matches{
            
            //saber cual es el index da cada pareja y eliminarlos
            
            var playerAId = match.playerA.objectID
            var playerBId = match.playerB.objectID
            
            if let indexA = find(players.map({$0.objectID}), playerAId){
                players.removeAtIndex(indexA)
            }
            
            if let indexB = find(players.map({$0.objectID}), playerBId){
                players.removeAtIndex(indexB)
            }
            
        }
        
    }
    
    func getPlayers(){
        
        if round == ""{
            
            getInitialPlayers()
            
            iniciarTorneo()
            
        }
        else if round == Tournament.firstMatch{
            
            getInitialPlayers()
            
            removePlayersPlayed()
            
        }
        else if round == Tournament.quarterFinals{
            
            getFirstMatchWinnersPlayers()
            
            removePlayersPlayed()
            
        }
        else if round == Tournament.semiFinals{
            
            getQuarterFinalsWinnersPlayers()
            
            removePlayersPlayed()
            
        }
        else if round == Tournament.finals{
            
            getSemiFinalsWinnersPlayers()
            
            
        }
        
        addNextButton()
                
    }
    
    func iniciarTorneo(){
        
        
        round = Tournament.firstMatch
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(round, forKey: "round")
        userDefaults.synchronize()
        
        tournament = NSEntityDescription.insertNewObjectForEntityForName("Tournament",
            inManagedObjectContext: self.managedObjectContext!) as! Tournament
        
        tournament.start = NSDate()
        
        save()
        
        next()
        
    }
    
    func isThereFinalWinner()->Bool{
        
        if tournament.completed.boolValue{
            return true
        }
    
        if let lastMatch = matches.last{
            
            if lastMatch.winA{
                lastMatch.playerA.finalCounter++
            }
            else if lastMatch.winB{
                lastMatch.playerB.finalCounter++
            }
            
        }
        
        var isThereFinalWinner = false
        
        for player in players{
            
            if player.finalCounter == 2{
                isThereFinalWinner = true
                tournament.winner = player
                tournament.completed = NSNumber(bool: true)
                tournament.end = NSDate()
                save()
            }
            
        }
        
        return isThereFinalWinner
        
    }
    
    func next(){
        
        if round == Tournament.finals{
            
            if isThereFinalWinner() {
                nextRound()
            }

        }
        
        if !tournament.completed.boolValue{
            if let lastMatch = matches.last{
                
                if lastMatch.isThereWinner(){
                    
                    if players.count > 0 {
                        nextMatch()
                    }
                    else{
                        nextRound()
                    }
                    
                }else{
                    lastMatch.nextMove()
                    tableView.reloadData()
                    animMove()
                }
                
            }
            else{
                nextMatch()
            }
        }else{
            nextRound()
        }
        
    }
    
    
    
    func nextMatch(){
        
        var match = NSEntityDescription.insertNewObjectForEntityForName("Match",
            inManagedObjectContext: self.managedObjectContext!) as! Match
        
        match.start = NSDate()
        
        if round != Tournament.finals{
            
            match.playerA = selectPlayerRandom()
            match.playerB = selectPlayerRandom()
            match.nextMove()

        }else{
            
            
            if finalCount == 0{
                match.playerA = players[0]
                match.playerB = players[1]
            }
            else if finalCount == 1{
                match.playerA = players[0]
                match.playerB = players[2]
            }
            else if finalCount == 2{
                match.playerA = players[1]
                match.playerB = players[2]
                finalCount -= 3
                
                resetFinalCounter()
                
            }
            
            finalCount++
            
            match.nextMove()
            
        }
        
        var roundMatches = tournament.mutableSetValueForKey(round)
        roundMatches.addObject(match)
        addMatch(match)
        
        tableView.reloadData()
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: matches.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        animMove()
        
        save()
        
    }
    
    func resetFinalCounter(){
        for player in players{
            player.finalCounter = 0
        }
    }
    
    func addMatch(match:Match){
        
        if round == Tournament.firstMatch {
            matchesFirstMatch.append(match)
        }
        if round == Tournament.quarterFinals {
            matchesQuarters.append(match)
        }
        if round == Tournament.semiFinals {
            matchesSemiFinal.append(match)
        }
        if round == Tournament.finals {
            matchesFinal.append(match)
        }

        
    }
    
    func selectPlayerRandom() -> Player{
        
        var random =  Int(arc4random_uniform(UInt32(players.count)))
        
        var player = players[random]
        players.removeAtIndex(random)
        
        return player
        
    }
    
    // MARK: - Nav
    
    func nextRound(){
        
        if round == Tournament.finals{
            
            mainController.lastWinner = tournament.winner
            mainController.initLastWinner(false)
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setValue("", forKey: "round")
            userDefaults.synchronize()
            
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            
        }else{
            var nextRound = ""
            if round == Tournament.firstMatch{
                nextRound = Tournament.quarterFinals
            }
            else if round == Tournament.quarterFinals{
                nextRound = Tournament.semiFinals
            }
            else if round == Tournament.semiFinals{
                nextRound = Tournament.finals
            }
            
            var matchesController = MatchesController()
            matchesController.round = nextRound
            matchesController.mainController = mainController
            
            self.navigationController?.pushViewController(matchesController, animated: true)
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 320
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var cell: MatchCell! = tableView.dequeueReusableCellWithIdentifier(idMatchCell, forIndexPath: indexPath) as? MatchCell
        
        if (cell == nil){
            cell = MatchCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: idMatchCell)
        }
            
        var match = matches[indexPath.row]
        
//        cell.textLabel?.text = "\(match.playerA.name) vs \(match.playerB.name)"
        
//        cell.detailTextLabel?.text = " \(match.movesArray.last?.moveA.capitalizedString) vs \(match.movesArray.last?.moveB.capitalizedString)"
        
        cell.avatarA.image = UIImage(data: match.playerA.avatar)
        cell.avatarB.image = UIImage(data: match.playerB.avatar)
        
        cell.nameA.text = match.playerA.name
        cell.genderA.text = match.playerA.genderEs
        cell.countryA.text = match.playerA.country
        let nameMoveA = match.movesArray.last?.moveAOption.image
        cell.moveA.image = UIImage(named: nameMoveA!)
        
        cell.nameB.text = match.playerB.name
        cell.genderB.text = match.playerB.genderEs
        cell.countryB.text = match.playerB.country
        let nameMoveB = match.movesArray.last?.moveBOption.image
        cell.moveB.image = UIImage(named: nameMoveB!)
        
        if match.isThereWinner() {
            if match.winA{
                cell.winA.text = "Ganó"
                cell.winA.winColor()
                cell.winB.text = "Perdió"
                cell.winB.loseColor()
            }else{
                cell.winB.text = "Ganó"
                cell.winB.winColor()
                cell.winA.text = "Perdió"
                cell.winA.loseColor()
            }
        }else{
            cell.winB.text = ""
            cell.winA.text = ""
        }
    
        return cell
    }
    

}
