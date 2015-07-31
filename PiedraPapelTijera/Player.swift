//
//  Player.swift
//  
//
//  Created by Gabriel Castañaza on 29/7/15.
//
//

import Foundation
import CoreData

@objc(Player)
class Player: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var gender: String
    @NSManaged var country: String
    @NSManaged var avatar: NSData
    
    var finalCounter = 0
    
    var genderEs:String{
        if gender == "F"{
            return "Mujer"
        }
        else if gender == "M"{
            return "Hombre"
        }
        else{
            return "Indefinido"
        }
    }

}
