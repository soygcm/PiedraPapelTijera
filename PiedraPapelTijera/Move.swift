//
//  Move.swift
//  PiedraPapelTijera
//
//  Created by Gabriel Castañaza on 29/7/15.
//  Copyright (c) 2015 Ministerio de Salud. All rights reserved.
//

import Foundation
import CoreData

struct MoveOption {
    var name:String = ""
    var code:String = ""
    var num:Int = 0
    var image:String = ""
}

@objc(Move)
class Move: NSManagedObject {

    @NSManaged var moveA: String
    @NSManaged var moveB: String
    @NSManaged var start: NSDate
    @NSManaged var end: NSDate
    
    var moveAOption = MoveOption()
    var moveBOption = MoveOption()
    
    static let options: [MoveOption] = [
        MoveOption(name: "Rock", code: "R", num: 0, image: "piedra"),
        MoveOption(name: "Paper", code: "P", num: 1, image: "papel"),
        MoveOption(name: "Scissors", code: "S", num: 2, image: "tijera")
    ]
    
    func winsA()->Bool{
        if( moveA == "R" && moveB == "P" ){
            return false
        }
        else if( moveA == "S" && moveB == "R" ){
            return false
        }
        else if( moveA == "P" && moveB == "S" ){
            return false
        }
        else if( moveA == "P" && moveB == "R" ){
            return true
        }
        else if( moveA == "R" && moveB == "S" ){
            return true
        }
        else if( moveA == "S" && moveB == "P" ){
            return true
        }
        else{
            return false
        }
    }
    
    func winsB()->Bool{
        if isThereWinner(){
            return !winsA()
        }else{
            return false
        }
    }
    
    func isThereWinner()->Bool{
        return moveA != moveB
    }
    
    func fillMoveOptions(){
        
        if let indexA = find(Move.options.map({$0.code}), moveA){
            moveAOption = Move.options[indexA]
        }
        
        if let indexB = find(Move.options.map({$0.code}), moveB){
            moveBOption = Move.options[indexB]
        }
        
    }

    func randomMovements(){
        
        var randomA =  Int(arc4random_uniform(UInt32(3)))
        var randomB =  Int(arc4random_uniform(UInt32(3)))
        
        moveAOption = Move.options[randomA]
        moveBOption = Move.options[randomB]
        
        moveA = moveAOption.code
        moveB = moveBOption.code
        
    }

}
