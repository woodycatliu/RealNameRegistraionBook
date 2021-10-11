//
//  Group+CoreDataClass.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/27.
//
//

import Foundation
import CoreData

public class Group: NSManagedObject {
    static let `default`: String = "其他"
    struct Key {
        static let name: String = "name"
    }
    var isOpening: Bool = false
}

extension Group {
    var placeList: [RealNamePlace] {
        return (places.allObjects as? [RealNamePlace])?.sorted(by: {
            guard let date1 = $0.date else { return false }
            guard let date2 = $1.date else { return true }
            return date1 > date2 }) ?? []
    }
}

