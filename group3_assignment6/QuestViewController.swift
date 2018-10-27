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
        questLog.text += "\nA monster suddenly appeared"
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
            questLog.text += "\n\(name) is defeated"
            userTimer.invalidate()
            enemyTimer.invalidate()
        } else {
            let userDamage = Int(floor(Float.random(in: 0...attack * 10)))
            questLog.text += "\n\(name) attacks for \(userDamage) damage"
            monsterHP -= userDamage
        }
        updateLabels()
    }
    
    @objc func enemyAttack() {
        if monsterHP <= 0 {
            questLog.text += "\nThe monster is defeated\n\(name) leveled up"
            attack += 0.5 + Float(Int.random(in: 0...50))
            level += 1
            userTimer.invalidate()
            enemyTimer.invalidate()
            startQuest()
        } else {
            let doesEnemyAttack = Int.random(in: 0 ... 4)
            if doesEnemyAttack == 0 {
                questLog.text += "\nThe monster is waiting..."
            } else {
                let enemyDamage = Int.random(in: 0 ... monsterAttack)
                questLog.text += "\nThe monster attacks \(name) for \(enemyDamage) damage"
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
    @IBAction func onEndQuest(_ sender: Any) {
        adventurer?.attack = attack
        adventurer?.totalHP = totalHP
        adventurer?.remainingHP = totalHP
        adventurer?.level = level
        
        Adventurer.adventurers[adventurerIndex] = adventurer!
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let person = AdventurersViewController.adventurers[adventurerIndex]
        
        person.setValue(remainingHP, forKeyPath: "remainingHP")
        person.setValue(totalHP, forKeyPath: "totalHP")
        person.setValue(attack, forKeyPath: "attack")
        person.setValue(level, forKeyPath: "level")
        
        do {
            try managedContext.save()
            AdventurersViewController.adventurers.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
