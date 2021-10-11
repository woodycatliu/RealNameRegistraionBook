//
//  CoreDataStack.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/25.
//

import Foundation
import CoreData

class CoreDataStack {
    
    enum EntitiesName: String{
        case group = "Group"
        case place = "RealNamePlace"
    }
    
    static let Model: String = "RealNameRegistraionBook"
            
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.Model)
        container.loadPersistentStores { _, error in
            if let error = error {
                #if DEBUG
                Logger.log(message: error)
                #else
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
                #endif
            }
        }
        return container
    }()
    
    // MARK: - Core Data Saving support
    @discardableResult
    func saveContext ()-> Bool {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch {
                Logger.log(message: error)
                return false
            }
        }
        return true
    }
    
    @discardableResult
    func saveContextBackground()-> Bool {
        let context = persistentContainer.backgroundContext()
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch {
                Logger.log(message: error)
                return false
            }
        }
        return true
    }
    
    
    func deleteAllData(entity: EntitiesName) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        if entity == .group {
            fetchRequest.predicate = NSPredicate(format: "name != %@", "其他")
        }
        
        if let objs = try? persistentContainer.viewContext.fetch(fetchRequest) {
            for obj in objs {
                persistentContainer.viewContext.delete(obj as! NSManagedObject)
            }
            do {
              try persistentContainer.viewContext.save()
            }
            catch {
                Logger.log(message: error)
            }
        }
    }
    
    
    /// delete speify entity into background and without notification
    func deleteDataIntoBackground(entity: EntitiesName) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let backgroundContext = persistentContainer.backgroundContext()
        do {
            try backgroundContext.execute(request)
            try backgroundContext.save()
        }
        catch {
            Logger.log(message: error)
        }
    }
    
}


class TestCoreDataStack: CoreDataStack {
    
    override init() {
        super.init()
        mockPersistantContainer()
    }
    
    private func mockPersistantContainer() {
        let description = NSPersistentStoreDescription()
         description.url = URL(fileURLWithPath: "/dev/null")
         let container = NSPersistentContainer(name: CoreDataStack.Model)
         container.persistentStoreDescriptions = [description]
         container.loadPersistentStores { _, error in
             if let error = error {
                 Logger.log(message: error)
             }
         }
        persistentContainer = container
    }
    
}

