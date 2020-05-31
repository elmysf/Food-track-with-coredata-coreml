//
//  CoreDataManager.swift
//  Food with coreml and coredata
//
//  Created by Ihwan ID on 30/05/20.
//  Copyright © 2020 Sufiandy Elmy. All rights reserved.
//

import CoreData
import UIKit

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Food_with_coreml_and_coredata")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Loading of store failed \(error)")
            }
        }
        
        return container
    }()
    
    @discardableResult
    func createFood(name: String, image: UIImage) -> Food? {
        let context = persistentContainer.viewContext
        
        let food = NSEntityDescription.insertNewObject(forEntityName: "Food", into: context) as! Food // NSManagedObject
        
        let imageData = image.jpegData(compressionQuality: 1.0)
        food.name = name
        food.image = imageData
        
        do {
            try context.save()
            return food
        } catch let createError {
            print("Failed to create: \(createError)")
        }
        
        return nil
    }
    
    func fetchFoods() -> [Food]? {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Food>(entityName: "Food")
        
        do {
            let foods = try context.fetch(fetchRequest)
            return foods
        } catch let fetchError {
            print("Failed to fetch foods: \(fetchError)")
        }
        
        return nil
    }
    
    func fetchFoods(withName name: String) -> Food? {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Food>(entityName: "Food")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let foods = try context.fetch(fetchRequest)
            return foods.first
        } catch let fetchError {
            print("Failed to fetch: \(fetchError)")
        }
        
        return nil
    }
    
    func updateFood(food: Food) {
        let context = persistentContainer.viewContext
        
        do {
            try context.save()
        } catch let createError {
            print("Failed to update: \(createError)")
        }
    }
    
    func deleteFood(food: Food) {
        let context = persistentContainer.viewContext
        context.delete(food)
        
        do {
            try context.save()
        } catch let saveError {
            print("Failed to delete: \(saveError)")
        }
    }
        func saveContext() {
            if persistentContainer.viewContext.hasChanges {
                do {
                    try persistentContainer.viewContext.save()
                } catch {
                    print("An error occurred while saving: \(error)")
                }
            }
        }
        
    }
