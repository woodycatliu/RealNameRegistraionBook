//
//  RealNamePlace+CoreDataProperties.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/27.
//
//

import Foundation
import CoreData


extension RealNamePlace {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RealNamePlace> {
        return NSFetchRequest<RealNamePlace>(entityName: "RealNamePlace")
    }

    @NSManaged public var message: String?
    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var group: Group?

}

extension RealNamePlace : Identifiable {

}
