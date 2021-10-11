//
//  String_Extension.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/30.
//

import Foundation


func RegularExpression(regex: String, validateString: String) -> [String]? {
    do {
        let regex: NSRegularExpression = try NSRegularExpression(pattern: regex, options: [])
        let matches = regex.matches(in: validateString, options: [], range: NSMakeRange(0, validateString.count))
        var data:[String] = Array()
        for item in matches {
            let string = (validateString as NSString).substring(with: item.range)
            data.append(string)
        }
        
        return data
    }
    catch {
        return nil
    }
}


