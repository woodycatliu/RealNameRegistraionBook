//
//  UIFont+Extension.swift
//  iOS_MomDad
//
//  Created by Woody Liu on 2021/5/31.
//

import UIKit

extension UIFont {
    
    class func TCMedium(size: CGFloat) -> UIFont {
        
        guard let font = UIFont(name: "PingFangTC-Medium", size: size) else { return .systemFont(ofSize: size )}
        return font
    }
    
    class func TCRegular(size: CGFloat) -> UIFont {
        
        guard let font = UIFont(name: "PingFangTC-Regular", size: size) else { return .systemFont(ofSize: size) }
        return font
    }
    
    class func TCSemibold(size: CGFloat) -> UIFont {
        
        guard let font = UIFont(name: "PingFangTC-Semibold", size: size) else { return .systemFont(ofSize: size) }
        return font
    }
    
    class func TCLight(size: CGFloat) -> UIFont {
        
        guard let font = UIFont(name: "PingFangTC-Light", size: size) else {return .systemFont(ofSize: size)}
        return font
    }
}
