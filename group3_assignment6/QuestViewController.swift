//
//  QuestViewController.swift
//  group3_assignment6
//
//  Created by Connor Ivy on 10/24/18.
//  Copyright © 2018 Ivy, Connor R. All rights reserved.
//

import UIKit

class QuestViewController: UIViewController {

    @IBOutlet weak var questLog: UITextView!
    @IBOutlet weak var HPLabel: UILabel!
    @IBOutlet weak var LevelLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    
    var userTimer = Timer()
    var enemyTimer = Timer()
    var adventurer = "DK"
    var level = 1
    var attack = 9
    var totalHP = 99
    var remainingHP = 99
    var monsterAttack = 20
    var monsterHP = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startQuest()
        // Do any additional setup after loading the view.
    }
    
    func startQuest() {
        questLog.text += "\r\nA Monster suddenly appeared"
        getMonster()
        
        userTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(userAttack), userInfo: nil, repeats: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
            self.enemyTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.enemyAttack), userInfo: nil, repeats: true)
        })
    }
    
    func getMonster() {
        monsterHP = 20
    }
    
    @objc func userAttack() {
        if remainingHP <= 0 {
            remainingHP = 0
            questLog.text += "\r\n\(adventurer) is defeated"
            userTimer.invalidate()
            enemyTimer.invalidate()
        }
        let userDamage = Int.random(in: 0 ... attack)
        questLog.text += "\r\n\(adventurer) attacks for \(userDamage) damage"
        monsterHP -= userDamage
        updateLabels()
    }
    
    @objc func enemyAttack() {
        if monsterHP <= 0 {
            questLog.text += "\r\nThe monster is defeated\r\n\(adventurer) leveled up"
            attack += 1
            level += 1
            userTimer.invalidate()
            enemyTimer.invalidate()
            startQuest()
        } else {
            let doesEnemyAttack = Int.random(in: 0 ... 4)
            if doesEnemyAttack == 0 {
                questLog.text += "\r\nThe monster is waiting..."
            } else {
                let enemyDamage = Int.random(in: 0 ... monsterAttack)
                questLog.text += "\r\nThe monster attacks \(adventurer) for \(enemyDamage)"
                remainingHP -= enemyDamage
            }
        }
        updateLabels()
    }

    func updateLabels() {
        HPLabel.text = "\(remainingHP)/\(totalHP)"
        LevelLabel.text = "\(level)"
        attackLabel.text = "\(attack)"
        
        if questLog.text.count > 0 {
            let location = questLog.text.count - 1
            let bottom = NSMakeRange(location, 1)
            questLog.scrollRangeToVisible(bottom)
        }
    }
}
