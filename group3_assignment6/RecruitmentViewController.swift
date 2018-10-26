//
//  RecruitmentViewController.swift
//  group3_assignment6
//
//  Created by Evan Shrestha on 10/18/18.
//  Copyright © 2018 Ivy, Connor R. All rights reserved.
//

import UIKit
import CoreData

class RecruitmentViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var enterName: UITextField!
    @IBOutlet weak var enterClass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        enterName.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSave(_ sender: Any) {
        let name = enterName.text
        let type = enterClass.text
        let adv = Adventurer(name: name!, image:"donkeykong.jpg", remainingHP: 100, totalHP:100, attack:1.00, level: 1, type: type!)
        saveAdventurer(adv: adv)
        
    }
    
    func saveAdventurer(adv : Adventurer) {
        
        
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
        let name = adv.name
        let image = adv.image
        let remainingHP = adv.remainingHP
        let totalHP = adv.totalHP
        let attack = adv.attack
        let level = adv.level
        let type = adv.type
            
            
            
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
            Adventurer.adventurers.append(adv)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
