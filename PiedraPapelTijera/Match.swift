//
//  Match.swift
//  PiedraPapelTijera
//
//  Created by Gabriel Castañaza on 29/7/15.
//  Copyright (c) 2015 Ministerio de Salud. All rights reserved.
//

import Foundation
import CoreData

@objc(Match)
class Match: NSManagedObject {

    @NSManaged var start: NSDate
    @NSManaged var end: NSDate
    @NSManaged var playerA: Player
    @NSManaged var playerB: Player
    @NSManaged var winner: Player
    @NSManaged var moves: NSSet
    
    var movesArray = [Move]()
    var winA = false
    var winB = false
    
    func fillMovesArray(){
        
        movesArray = moves.allObjects as! [Move]
        
        for move in movesArray{
            move.fillMoveOptions()
        }
        
    }

    func nextMove(){
        
        var move = NSEntityDescription.insertNewObjectForEntityForName("Move",
            inManagedObjectContext: self.managedObjectContext!) as! Move
        
        move.randomMovements()
        move.start = NSDate()
        move.end = NSDate()
        
        var movesM = self.mutableSetValueForKey("moves")
        movesM.addObject(move)
        
        movesArray.append(move)
        
        save()
    }
    
    func save() {
        var error : NSError?
        if( !managedObjectContext!.save(&error) ) {
            println(error?.localizedDescription)
        }
    }
    
    func isThereWinner() -> Bool{
        
        var lastMove = movesArray.last
        
        if lastMove!.winsA() {
            winner = playerA
            winA = true
        }else if lastMove!.winsB() {
            winner = playerB
            winB = true
        }
        
        if lastMove!.isThereWinner() {
            self.end = NSDate()
        }
        
        return lastMove!.isThereWinner()
        
    }
    
    
}
