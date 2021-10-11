//
//  Group+CoreDataProperties.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/27.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var name: String?
    @NSManaged public var sort: Int64
    @NSManaged public var places: NSSet

}

// MARK: Generated accessors for places
extension Group {

    @objc(addPlacesObject:)
    @NSManaged public func addToPlaces(_ value: RealNamePlace)

    @objc(removePlacesObject:)
    @NSManaged public func removeFromPlaces(_ value: RealNamePlace)

    @objc(addPlaces:)
    @NSManaged public func addToPlaces(_ values: NSSet)

    @objc(removePlaces:)
    @NSManaged public func removeFromPlaces(_ values: NSSet)

}

extension Group : Identifiable {

}
