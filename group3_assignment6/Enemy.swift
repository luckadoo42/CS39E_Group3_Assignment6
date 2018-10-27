//
//  Enemy.swift
//  group3_assignment6
//
//  Created by Evan Shrestha on 10/26/18.
//  Copyright © 2018 Ivy, Connor R. All rights reserved.
//

import Foundation

class Enemy {
    var attack : Float = 1.0
    var totalHP : Int = 100
    var remainingHP : Int = 100
    var name : String = "Enemy"
    var level : Int = 1
    static let enemyNames : [String] = ["Mario", "Luigi", "Bowser", "Peach", "Toad"]
    
    init(name: String, level: Int, attack: Float, totalHP: Int, remainingHP: Int) {
        self.name = name
        self.level = level
        self.attack = attack
        self.totalHP = totalHP
        self.remainingHP = remainingHP
    }
    
    static func generateEnemy() -> Enemy {
        
        let randomName : String = Enemy.enemyNames[Int.random(in: 0..<Enemy.enemyNames.count)]
        let randomAttack = Float(Int.random(in: 50...150)) / 100
        let randomHP = Int.random(in: 15...30)
        let newEnemy = Enemy(name: randomName, level: 1, attack: randomAttack, totalHP: randomHP, remainingHP: randomHP)
        
        return newEnemy
    }
}
