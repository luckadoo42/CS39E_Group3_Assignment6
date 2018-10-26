//
//  QuestViewController.swift
//  group3_assignment6
//
//  Created by Connor Ivy on 10/24/18.
//  Copyright © 2018 Ivy, Connor R. All rights reserved.
//

import UIKit
import CoreData

class QuestViewController: UIViewController {

    @IBOutlet weak var questLog: UITextView!
    @IBOutlet weak var HPLabel: UILabel!
    @IBOutlet weak var LevelLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var adventurerImage: UIImageView!
    
    var userTimer = Timer()
    var enemyTimer = Timer()
    var name = "DK"
    var adventurerIndex = 0
    
    var adventurer : Adventurer? = nil
    
    var level = 1
    var attack : Float = 9
    var totalHP = 99
    var type = "Bard"
    var remainingHP = 99
    var monsterAttack = 20
    var monsterHP = 20
    var image = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (adventurer != nil) {
            name = adventurer!.name
            level = adventurer!.level
            attack = adventurer!.attack
            totalHP = adventurer!.totalHP
            remainingHP = adventurer!.remainingHP
            type = adventurer!.type
            image = adventurer!.image
            startQuest()
            updateLabels()
        }
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
            questLog.text += "\r\n\(name) is defeated"
            userTimer.invalidate()
            enemyTimer.invalidate()
        }
        let userDamage = Int(floor(Float.random(in: 0...attack * 10)))
        questLog.text += "\r\n\(name) attacks for \(userDamage) damage"
        monsterHP -= userDamage
        updateLabels()
    }
    
    @objc func enemyAttack() {
        if monsterHP <= 0 {
            questLog.text += "\r\nThe monster is defeated\r\n\(name) leveled up"
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
                questLog.text += "\r\nThe monster attacks \(name) for \(enemyDamage)"
                remainingHP -= enemyDamage
            }
        }
        updateLabels()
    }

    func updateLabels() {
        HPLabel.text = "\(remainingHP)/\(totalHP)"
        LevelLabel.text = "\(level)"
        attackLabel.text = "\(attack)"
        nameLabel.text = "\(name)"
        typeLabel.text = "\(type)"
        adventurerImage.image = UIImage(named: image)
        
        if questLog.text.count > 0 {
            let location = questLog.text.count - 1
            let bottom = NSMakeRange(location, 1)
            questLog.scrollRangeToVisible(bottom)
        }
    }
    @IBAction func onDelete(_ sender: Any) {
        deleteAdventurer()
    }
    
    func deleteAdventurer() {
        Adventurer.adventurers.remove(at: adventurerIndex)
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Characters")
        
        if (try? managedContext.fetch(fetchRequest)) != nil {
            managedContext.delete(AdventurersViewController.adventurers[adventurerIndex])
            do {
                try managedContext.save()
            } catch {
                print("uh oh")
            }
        }
        
        performSegue(withIdentifier: "toTableView", sender: self)
    }
}
