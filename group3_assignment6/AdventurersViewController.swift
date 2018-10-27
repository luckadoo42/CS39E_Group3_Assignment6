//
//  AdventurersViewController.swift
//  group3_assignment6
//
//  Created by Evan Shrestha on 10/18/18.
//  Copyright © 2018 Ivy, Connor R. All rights reserved.
//

import UIKit
import CoreData

class AdventurersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var characterTableView: UITableView!
    
    
    static var adventurers: [NSManagedObject] = []
    var selectedAdventurer: Adventurer?
    var selectedAdventurerIndex: Int?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Adventurer.adventurers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let adventurer = Adventurer.adventurers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "adventurerCell") as! AdventurerTableViewCell
        
        cell.adventurerImage.image = UIImage(named: adventurer.image)
        cell.adventurerType.text = adventurer.type
        cell.adventurerLevel.text = String(adventurer.level)
        cell.adventurerAttack.text = "ATTACK: " + String(adventurer.attack)
        cell.adventurerHP.text = "HP: " + String(adventurer.remainingHP) + "/" + String(adventurer.totalHP)
        cell.adventurerName.text = adventurer.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(155)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAdventurer = Adventurer.adventurers[indexPath.row]
        selectedAdventurerIndex = indexPath.row
        performSegue(withIdentifier: "questView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "questView") {
            let vc = segue.destination as! QuestViewController
            vc.adventurer = selectedAdventurer
            vc.adventurerIndex = selectedAdventurerIndex!
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Characters")
        
        do {
            AdventurersViewController.adventurers = try managedContext.fetch(fetchRequest)
            print(AdventurersViewController.adventurers.count)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        // This only needs to be run once to save the info to the CoreData
        // Initial values
        let names = ["Donkey Kong", "King K. Rool", "Klump", "Diddy Kong", "Squawks", "Funky Kong", "Rambi the Rhino", "Cranky Kong"]
        let images = ["donkeykong.jpg", "kingkrool.jpg", "klump.jpg", "diddykong.jpg", "squawks.jpg", "funkykong.jpg", "rambi.jpg", "crankykong.jpg"]
        let remainingHPs = [100, 100, 120, 120, 110, 105, 107, 108]
        let totalHPs = [100, 100, 120, 120, 110, 105, 107, 108]
        let attacks:[Float] = [1.00, 2.21, 2.12, 1.21, 5.2, 6.52, 3.42, 2.12]
        let levels = [5, 2, 3, 6, 1, 2, 3, 8]
        let types = ["Bard", "Mage", "Warrior", "Archer", "Tree", "Muffin", "Elf", "Human"]
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        print(launchedBefore)
        if (!launchedBefore) {
            for i in 0..<names.count {
                let adv = Adventurer(name: names[i], image: images[i], remainingHP: remainingHPs[i], totalHP: totalHPs[i], attack: attacks[i], level: levels[i], type: types[i])
                Adventurer.adventurers.append(adv)
                
            }
            for i in 0..<Adventurer.adventurers.count {
                let adventurer = Adventurer.adventurers[i]
                addInitialCharacters(name: adventurer.name, image: adventurer.image, remainingHP: adventurer.remainingHP, totalHP: adventurer.totalHP, attack: adventurer.attack, level: adventurer.level, type: adventurer.type)
            }
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        } else {
            for i in 0..<AdventurersViewController.adventurers.count {
                let adventurer = AdventurersViewController.adventurers[i]
                
                let name = adventurer.value(forKeyPath: "name") as! String
                let image = adventurer.value(forKeyPath: "image") as! String
                let remainingHP = adventurer.value(forKeyPath: "remainingHP") as! Int
                let totalHP = adventurer.value(forKeyPath: "totalHP") as! Int
                let attack = adventurer.value(forKeyPath: "attack") as! Float
                let level = adventurer.value(forKeyPath: "level") as! Int
                let type = adventurer.value(forKeyPath: "type") as! String
                
                let adv = Adventurer(name: name, image: image, remainingHP: remainingHP, totalHP: totalHP, attack: attack, level: level, type: type)
                
                Adventurer.adventurers.append(adv)
            }
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(Adventurer.adventurers.count)
        self.characterTableView.reloadData()
        
        
        
//        // Uncomment this section to delete all the data written in the character entity of core data
//
//
//        if let result = try? managedContext.fetch(fetchRequest) {
//            for object in result {
//                managedContext.delete(object)
//            }
//            do {
//                try managedContext.save()
//            } catch {
//                print("uh oh")
//            }
//        }
        
        
        
    }
    
    
    
    func addInitialCharacters(name: String, image: String, remainingHP : Int, totalHP: Int, attack : Float, level: Int, type:String) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }

        let managedContext =
            appDelegate.persistentContainer.viewContext

        let entity =
            NSEntityDescription.entity(forEntityName: "Characters",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)

        person.setValue(name, forKeyPath: "name")
        person.setValue(image, forKeyPath: "image")
        person.setValue(remainingHP, forKeyPath: "remainingHP")
        person.setValue(totalHP, forKeyPath: "totalHP")
        person.setValue(attack, forKeyPath: "attack")
        person.setValue(level, forKeyPath: "level")
        person.setValue(type, forKeyPath: "type")
        
        do {
            try managedContext.save()
            AdventurersViewController.adventurers.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
