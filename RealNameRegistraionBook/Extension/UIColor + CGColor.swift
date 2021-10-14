//
//  UIColor.swift
//  iOS_MomDad
//
//  Created by Woody Liu on 2021/6/3.
//

import UIKit


extension UIColor {
    
    static let mainColor: UIColor = {
        return UIColor(hex: "64CCDA")
    }()
    
    static let pink: UIColor = {
        return UIColor.rgba(r: 246, g: 198, b: 255, a: 1)
    }()
}


extension CGColor {
    
    static let mainColor: CGColor = {
        return UIColor.mainColor.cgColor
    }()
        
    
}

