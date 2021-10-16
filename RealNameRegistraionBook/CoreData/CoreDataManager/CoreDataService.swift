//
//  CoreDataManager.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/25.
//

import Foundation
import CoreData
import Combine


class CoreDataService: NSObject {
    
    enum SortNumber: Int64 {
        case last = 999
        case mid = 450
        case priority = 1
    }
    
    static let shared: CoreDataService = CoreDataService()
    
    private(set) var coreDataStack: CoreDataStack
    
    private(set) var otherGroup: Group?
    
    var context: NSManagedObjectContext {
        coreDataStack.persistentContainer.viewContext
    }
    
    private(set) var contentDidChange = PassthroughSubject<Bool, Never>()
    
    init(_ coredataStack: CoreDataStack = CoreDataStack()) {
        self.coreDataStack = coredataStack
        super.init()
        // default entity - default == "其他"
        otherGroup = addGroup(name: Group.default, sortNumber: .last)
        
        #if DEBUG
        let sample1 = addPlace(message: "0000 0000 000 這是1922示範簡訊")
        let sample2 = addPlace(message: "0000 0000 001 這是1922示範簡訊")
        guard let group = addGroup(name: "範例") else { return }
        sample1?.changeGroup(group)
        sample2?.changeGroup(group)
        #endif
    }
    
    lazy var fetchController: NSFetchedResultsController<Group> = {
        let request = Group.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "sort", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "name", cacheName: nil)
        controller.managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        controller.delegate = self
        
        do {
            try controller.performFetch()
        }
        catch let error as NSError {
            Logger.log(message: error)
        }
        return controller
    }()
    
    func deleteAllData(entity: CoreDataStack.EntitiesName) {
        coreDataStack.deleteAllData(entity: entity)
    }
    
}


// MARK: mumtate
extension CoreDataService {
    
    @discardableResult
    func addGroup(name: String, sortNumber: SortNumber = SortNumber.mid)-> Group? {
        if let group = checkGroupExists(name: name) {
            return group
        }
        
        let group = Group(context: self.context)
        group.name = name
        group.sort = sortNumber.rawValue
        return coreDataStack.saveContext() ? group : nil
    }
    
    @discardableResult
    func addPlace(message: String)-> RealNamePlace? {
        if let place = checkPlaceExists(message: message) {
            return place
        }
        
        let place = RealNamePlace(context: self.context)
        place.message = message
        place.date = Date()
        if let group = otherGroup {
            group.addToPlaces(place)
        }
        return coreDataStack.saveContext() ? place : nil
    }
    
    /// Check Group is exists of name
    func checkGroupExists(name: String)-> Group? {
        let request = Group.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        
        if let groups = try? context.fetch(request) {
            return groups.first
        }
        return nil
    }
    
    /// Check RealNamePlace is exists of name
    func checkPlaceExists(message: String)-> RealNamePlace? {
        let request = RealNamePlace.fetchRequest()
        request.predicate = NSPredicate(format: "message == %@", message)
        if let results = try? context.fetch(request) {
            return results.first
        }
        return nil
    }
    
}

// MARK: move or delete
extension CoreDataService {
    
    enum EntityType {
        case group
        case place
    }
    
    var groupList: [Group] {
        return fetchController.fetchedObjects ?? []
    }
    
    func getPlace(_ indexPath: IndexPath)-> RealNamePlace? {
        guard groupList.indices.contains(indexPath.section),
              groupList[indexPath.section].placeList.indices.contains(indexPath.row)
        else {  return nil  }
        
        return groupList[indexPath.section].placeList[indexPath.row]
    }
    
    func getPlaces(_ indexPaths: [IndexPath])-> [RealNamePlace] {
        return indexPaths.compactMap {
            return getPlace($0)
        }
    }
    
    func getGroup(_ section: Int)-> Group? {
        return groupList.indices.contains(section) ? groupList[section] : nil
    }
    
    func changePlaceOfGroup(_ indexPath: IndexPath, groupSection section: Int) {
        guard let place = getPlace(indexPath),
              let group = getGroup(section) else { return }
        place.changeGroup(group)
        _ = coreDataStack.saveContext()
    }
    
    func updateName(indexPath: IndexPath, name: String, type: EntityType) {
        switch type {
        case .group:
            if let group = getGroup(indexPath.row) {
                group.name = name
            }
            
        case .place:
            if let place = getPlace(indexPath) {
                place.name = name
            }
        }
        coreDataStack.saveContext()
        context.refreshAllObjects()
    }
    
    func deleteGroup(section: Int) {
        guard let group = getGroup(section),
              let otherGroup = otherGroup else { return }
        group.placeList.forEach {
            $0.changeGroup(otherGroup)
        }
        context.delete(group)
        coreDataStack.saveContext()
    }
    
    func deletePlace(indexPath: IndexPath) {
        guard let place = getPlace(indexPath) else { return }
        context.delete(place)
        coreDataStack.saveContext()
    }
    
    func deletePlaces(indexPaths: [IndexPath]) {
        var cache: [RealNamePlace] = []
        indexPaths.forEach {
            if let place = getPlace($0) {
                cache.append(place)
            }
        }
        cache.forEach {
            context.delete($0)
        }
        coreDataStack.saveContext()
    }
    
    func removeToGroup(places: [RealNamePlace], groupSection section: Int) {
        guard let group = getGroup(section) else { return }
        places.forEach {
            $0.changeGroup(group)
        }
        coreDataStack.saveContext()
    }
    
    func removeToGroup(indexPaths: [IndexPath], groupSection section: Int) {
        guard let group = getGroup(section) else { return }
        var cache: [RealNamePlace] = []
        indexPaths.forEach {
            if let place = getPlace($0) {
                cache.append(place)
            }
        }
        cache.forEach {
            $0.changeGroup(group)
        }
        coreDataStack.saveContext()
    }
    
    func changeGroupName(indexPath: IndexPath, name: String) {
        guard let group = getGroup(indexPath.row) else { return }
        group.name = name
        coreDataStack.saveContext()
    }
    
    
}

extension CoreDataService {
    
    func object(with objectIDString: String)-> RealNamePlace? {
        guard let url = URL(string: objectIDString),
              let objectID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url)
        else { return nil }
        
        return context.object(with: objectID) as? RealNamePlace
    }
    
    func object(with objectID: NSCopying)-> RealNamePlace? {
        guard let objectID = objectID as? NSManagedObjectID
        else { return nil }
        
        return context.object(with: objectID) as? RealNamePlace
    }
    
    func placeIndex(place: RealNamePlace)-> IndexPath? {
        guard let group = place.group,
              let section = fetchController.fetchedObjects?.firstIndex(of: group),
              let row = group.placeList.firstIndex(of: place)
        else { return nil }

        return IndexPath(row: row, section: section)
    }
}



// MARK: NSFetchedResultsControllerDelegate
extension CoreDataService: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        contentDidChange.send(true)
    }
    
}
