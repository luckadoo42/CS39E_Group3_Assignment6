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
    
    var adventurers: [NSManagedObject] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adventurers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let adventurer = adventurers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "adventurerCell") as! AdventurerTableViewCell
        
        if adventurer.value(forKeyPath: "image") != nil {
        cell.adventurerImage.image = UIImage(named: adventurer.value(forKeyPath: "image") as! String)
        }
        else {
            cell.adventurerImage.image = UIImage(named: "donkeykong.jpg")
        }
        cell.adventurerName.text = adventurer.value(forKeyPath: "name") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(155)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // This only needs to be run once to save the info to the CoreData
//        addInitialCharacters(name: "Donkey Kong", image: "donkeykong.jpg")
//        addInitialCharacters(name: "King K. Rool", image: "kingkrool.jpg")
//        addInitialCharacters(name: "Klump", image: "klump.jpg")
//        addInitialCharacters(name: "Diddy Kong", image: "diddykong.jpg")
//        addInitialCharacters(name: "Squawks", image: "squawks.jpg")
//        addInitialCharacters(name: "Funky Kong", image: "funkykong.jpg")
//        addInitialCharacters(name: "Rambi the Rhino", image: "rambi.jpg")
//        addInitialCharacters(name: "Cranky Kong", image: "crankykong.jpg")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Characters")
        
        do {
            adventurers = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
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
    
    func addInitialCharacters(name: String, image: String) {
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

        do {
            try managedContext.save()
            adventurers.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
