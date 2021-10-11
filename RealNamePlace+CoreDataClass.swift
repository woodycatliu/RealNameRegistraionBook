//
//  RealNamePlace+CoreDataClass.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/27.
//
//

import Foundation
import CoreData


public class RealNamePlace: NSManagedObject {
    struct Key {
        static let name: String = "name"
        static let message: String = "message"
        static let group: String = "group"
    }
    
}

extension RealNamePlace {
    func changeGroup(_ group: Group) {
        setValue(group, forKey: RealNamePlace.Key.group)
    }
    
    func regex()-> String? {
        guard let message = message,
              var data = RegularExpression(regex: "\\d{3,4}", validateString: message) else { return message }
    
        if data.count > 4 {
            data = Array(data.prefix(4))
        }
        
        return data.joined(separator: " ")
    }
}
