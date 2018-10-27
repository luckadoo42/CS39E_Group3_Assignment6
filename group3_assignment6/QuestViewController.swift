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
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    var userTimer = Timer()
    var enemyTimer = Timer()
    
    var adventurerIndex = 0
    
    var adventurer : Adventurer? = nil
    
    var enemy : Enemy? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (adventurer != nil) {
            startQuest()
            updateLabels()
        }
        // Do any additional setup after loading the view.
    }
    
    func startQuest() {
        getMonster()
        questLog.text += "\nEnemy \(enemy!.name) suddenly appeared"
        
        userTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(userAttack), userInfo: nil, repeats: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
            self.enemyTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.enemyAttack), userInfo: nil, repeats: true)
        })
    }
    
    func getMonster() {
        enemy = Enemy.generateEnemy()
    }
    
    @objc func userAttack() {
        if adventurer!.remainingHP <= 0 {
            adventurer!.remainingHP = 0
            updateLabels()
            questLog.text += "\n\(adventurer!.name) is defeated"
            userTimer.invalidate()
            enemyTimer.invalidate()
        } else {
            let userDamage = Int(floor(Float.random(in: 0...adventurer!.attack * 10)))
            questLog.text += "\n\(adventurer!.name) attacks for \(userDamage) damage"
            enemy!.remainingHP -= userDamage
        }
        updateLabels()
    }
    
    @objc func enemyAttack() {
        if enemy!.remainingHP <= 0 {
            questLog.text += "\n\(enemy!.name) is defeated"
            adventurer!.experience += Int.random(in: 200...800)
            let levelUps = Int(floor(Float(adventurer!.experience) / 1000))
            if levelUps > 0 {
                questLog.text += "\n\(adventurer!.name) leveled up"
                adventurer!.level += levelUps
                adventurer!.experience = adventurer!.experience - levelUps * 1000
                adventurer!.attack += Float(Int.random(in: 50...100)) / 100.0
                adventurer!.defense = adventurer!.defense + Float.random(in: 0..<(1 - adventurer!.defense)/4)
            }
            updateLabels()
            userTimer.invalidate()
            enemyTimer.invalidate()
            startQuest()
        } else {
            let doesEnemyAttack = Int.random(in: 0 ... 4)
            if doesEnemyAttack == 0 {
                questLog.text += "\n\(enemy!.name) is waiting..."
            } else {
                let enemyDamage = Int(floor(10 * (enemy!.attack) * (1.00 - adventurer!.defense)))
                questLog.text += "\n\(enemy!.name) attacks \(adventurer!.name) for \(enemyDamage) damage"
                adventurer!.remainingHP -= enemyDamage
            }
        }
        updateLabels()
    }

    func updateLabels() {
        HPLabel.text = "\(adventurer!.remainingHP)/\(adventurer!.totalHP)"
        LevelLabel.text = "\(adventurer!.level)"
        attackLabel.text = "\(adventurer!.attack)"
        nameLabel.text = "\(adventurer!.name)"
        typeLabel.text = "\(adventurer!.type)"
        experienceLabel.text = "XP: \(adventurer!.experience)/1000"
        defenseLabel.text = "Defense: \(adventurer!.defense)"
        adventurerImage.image = UIImage(named: adventurer!.image)
        
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
        adventurer!.remainingHP = adventurer!.totalHP
        Adventurer.adventurers[adventurerIndex] = adventurer!
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let person = AdventurersViewController.adventurers[adventurerIndex]
        
        person.setValue(adventurer!.remainingHP, forKeyPath: "remainingHP")
        person.setValue(adventurer!.totalHP, forKeyPath: "totalHP")
        person.setValue(adventurer!.attack, forKeyPath: "attack")
        person.setValue(adventurer!.level, forKeyPath: "level")
        person.setValue(adventurer!.experience, forKeyPath: "experience")
        person.setValue(adventurer!.defense, forKeyPath: "defense")
        
        do {
            try managedContext.save()
            AdventurersViewController.adventurers.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
