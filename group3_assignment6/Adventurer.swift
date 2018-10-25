//
//  Adventurer.swift
//  group3_assignment6
//
//  Created by Evan Shrestha on 10/24/18.
//  Copyright © 2018 Ivy, Connor R. All rights reserved.
//

import Foundation


class Adventurer {
    static var adventurers = [Adventurer]() // Somewhat redundant with the other adventurers array right now
    var name : String = ""
    var image : String = ""
    var remainingHP : Int = 100
    var totalHP : Int = 100
    var attack : Float = 1.00
    var level : Int = 1
    var type : String = ""
    
    init(name: String, image:String, remainingHP: Int, totalHP:Int, attack:Float, level: Int, type: String) {
        
        self.name = name
        self.image = image
        self.remainingHP = remainingHP
        self.totalHP = totalHP
        self.attack = attack
        self.level = level
        self.type = type

    }
}
