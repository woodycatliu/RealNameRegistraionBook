//
//  CGFloat+Extension.swift
//  iOS_MomDad
//
//  Created by Woody Liu on 2021/5/31.
//

import UIKit


extension CGFloat {
    static func scaleOfLength(length: CGFloat, isWidth: Bool)-> CGFloat {
        let height: CGFloat = 812
        let width: CGFloat = 375
        
        if isWidth {
            return length / width
        }
        return length / height
    }
    
    
    static func realLengthForScale(length: CGFloat, isWidth: Bool)-> CGFloat {
        let bounds: CGRect = UIScreen.main.bounds
        let height: CGFloat = 812
        let width: CGFloat = 375
        
        if isWidth {
            return length / width * bounds.width
        }
        return length / height * bounds.height
    }
    
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static func adjustFloat(min: CGFloat, max: CGFloat)-> CGFloat {
        return UIScreen.main.bounds.height < 812 ? min : max
    }
}
