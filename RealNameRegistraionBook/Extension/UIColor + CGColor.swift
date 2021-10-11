//
//  UIColor.swift
//  iOS_MomDad
//
//  Created by Woody Liu on 2021/6/3.
//

import UIKit


extension UIColor {
    
    static let mainColor: UIColor = {
        return UIColor(hex: "5BE3FF")
    }()
    
    static let mainLightGreen: UIColor = {
        return UIColor(red: 160 / 255, green: 251 / 255, blue: 253 / 255, alpha: 0.155)
    }()
    
    static let mainBackground: UIColor = {
        return .rgba(rgb: 248, a: 1)
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

