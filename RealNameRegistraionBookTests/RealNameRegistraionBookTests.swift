//
//  RealNameRegistraionBookTests.swift
//  RealNameRegistraionBookTests
//
//  Created by Woody Liu on 2021/9/25.
//

import XCTest
@testable import RealNameRegistraionBook

class RealNameRegistraionBookTests: XCTestCase {
    
    let manager: CoreDataService = CoreDataService(TestCoreDataStack())
    
    
    override func setUp() {
        super.setUp()
        
        Logger.log(message: "##########\(manager.fetchController.sections?.count)")
        
        _ = manager.addGroup(name: "Shit")
//
        _ = manager.addGroup(name: "Bow")
//

    }


    override func tearDownWithError() throws {
//        manager.deleteAllData(entity: .group)
//        manager.deleteAllData(entity: .place)

    }

//    func testExample() throws {
//
//        try manager.fetchController.performFetch()
//
////        XCTAssertEqual(manager.controller.fetchedObjects?.count, 2)
//
//        _ = manager.addGroup(name: "Shsssit")
//
////        XCTAssertEqual(manager.controller.fetchedObjects?.count, 2)
//
//        manager.deleteAllData(entity: .group)
//
//    manager.addPlace(message: "1234569")
//
//
//        let groupFetch = Group.fetchRequest()
//        groupFetch.predicate = NSPredicate(format: "name = %@", "其他")
//
//        let results = try? manager.context.fetch(groupFetch) as [Group]
//
//        let otherGroup = results?.first
//
//        print("SSSSSS:", otherGroup?.placeList?.first?.message)
//
//        manager.addPlace(message: "Sdmadmw")
//    }

    
    func testMove() throws {
        
        let place = manager.addPlace(message: "Mommy")
        
        let place2 = manager.addPlace(message: "Daddy")
        
        if let groupp = manager.addGroup(name: "Group") {
            place2?.changeGroup(groupp)
        }
        
        let group2 = manager.addGroup(name: "Group2")
        
        
        manager.coreDataStack.saveContext()
        
//        let value = manager.fetchController.object(at: IndexPath(item: 0, section: 0))
//        print("value:", value)
        
        
        
        
        
        
        print("--------------------- Start ---------------------")
        print("Sections:", manager.fetchController.sections?.count)
        manager.fetchController.sections?.forEach {
            print("################### Section ###################")
            print("count:", $0.numberOfObjects)
            print("name:", $0.name)
            print("totle:", $0.indexTitle)
            print($0.objects)
            print("################### End ###################")

        }
        
        print("--------------------- Stop ---------------------")

        
        
//
//        if let sections = manager.fetchController.sections,
//           let orignSection = manager.fetchController.indexPath(forObject: place!.group!)?.section,
//           let group = (sections[orignSection].objects as? [Group])?.first,
//           let realplaces = group.placeList,
//           let orignRow = realplaces.firstIndex(of: place!){
////           let orignRow = realplaces.firstIndex(of: place!) {
//            print(orignRow)
//            manager.movePlace(from: IndexPath(row: orignRow, section: orignSection), to: IndexPath(item: 0, section: 0))
//
//            let request = RealNamePlace.fetchRequest()
//            request.predicate = NSPredicate(format: "message == %@", "Mommy")
//
//            let places = try? manager.context.fetch(request) as [RealNamePlace]
//
//            print("placesplaces:", places?.first?.group?.name)
             
//        }
           
    }
    
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension RealNameRegistraionBookTests {
    
    
    
    
}
