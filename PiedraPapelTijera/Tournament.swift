//
//  Tournament.swift
//  PiedraPapelTijera
//
//  Created by Gabriel Castañaza on 29/7/15.
//  Copyright (c) 2015 Ministerio de Salud. All rights reserved.
//

import Foundation
import CoreData

@objc(Tournament)
class Tournament: NSManagedObject {

    @NSManaged var start: NSDate
    @NSManaged var end: NSDate
    @NSManaged var completed: NSNumber
    @NSManaged var winner: Player
    @NSManaged var firstMatch: NSSet
    @NSManaged var quarterFinals: NSSet
    @NSManaged var semiFinals: NSSet
    @NSManaged var finals: NSSet

    static let firstMatch = "firstMatch"
    static let quarterFinals = "quarterFinals"
    static let semiFinals = "semiFinals"
    static let finals = "finals"
    
}
