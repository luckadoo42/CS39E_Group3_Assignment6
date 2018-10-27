//
//  RecruitmentViewController.swift
//  group3_assignment6
//
//  Created by Evan Shrestha on 10/18/18.
//  Copyright © 2018 Ivy, Connor R. All rights reserved.
//

import UIKit
import CoreData

class RecruitmentViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    let images = ["donkeykong.jpg", "kingkrool.jpg", "klump.jpg", "diddykong.jpg", "squawks.jpg", "funkykong.jpg", "rambi.jpg", "crankykong.jpg"]
    
    var selectedImage = "donkeykong.jpg"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "recruitmentImageCell", for: indexPath) as! RecruitmentImageCollectionViewCell
        
        cell.imageView.image = UIImage(named: images[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0..<images.count {
            let cell = collectionView.cellForItem(at: IndexPath(row: i, section: 0))
            if i == indexPath.item {
                cell?.backgroundColor = UIColor.gray
            } else {
                cell?.backgroundColor = UIColor.white
            }
        }
        
        selectedImage = images[indexPath.item]
        print(selectedImage)
        
    }
    

    @IBOutlet weak var enterName: UITextField!
    @IBOutlet weak var enterClass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        

//        enterName.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        imageCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: [])
        
    }

    @IBAction func onSave(_ sender: Any) {
        let name = enterName.text
        let type = enterClass.text
        let image = selectedImage
        
        if (!name!.trimmingCharacters(in: .whitespaces).isEmpty && !type!.trimmingCharacters(in: .whitespaces).isEmpty) {
            
            let randomAttackMultiplier = Float(Int.random(in: 50...150)) / 100
            let randomTotalHP = Int.random(in: 80...120)
            
            
            let adv = Adventurer(name: name!, image: image, remainingHP: randomTotalHP, totalHP:randomTotalHP, attack:randomAttackMultiplier, level: 1, type: type!, experience: 0, defense: 0.00)
            saveAdventurer(adv: adv)
            performSegue(withIdentifier: "saveSegue", sender: self)
        }
        
        
        
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
