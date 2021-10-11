//
//  UIColor+Extension.swift
//  iOS_MomDad
//
//  Created by Woody Liu on 2021/5/31.
//

import UIKit

extension UIColor {
    
    class func rgba(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        let redFloat = r / 255
        let green = g / 255
        let blue = b / 255
        return UIColor(red: redFloat, green: green, blue: blue, alpha: a)
    }
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1)
    }

    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#"),
           let first = hexWithoutSymbol.firstIndex(of: "#") {
            hexWithoutSymbol.remove(at: first)
        }
        
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt: UInt64 = 0x0
        scanner.scanHexInt64(&hexInt)
        
        var r: UInt64!, g: UInt64!, b: UInt64!
        switch (hexWithoutSymbol.length) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
        default:
            // TODO:ERROR
            break
        }
        
        self.init(
            red: (CGFloat(r)/255),
            green: (CGFloat(g)/255),
            blue: (CGFloat(b)/255),
            alpha: alpha)
    }
}


extension UIColor {
    
    class func rgba(rgb: CGFloat, a: CGFloat)-> UIColor {
        let rgb = rgb / 255
        return UIColor(red: rgb, green: rgb, blue: rgb, alpha: a)
    }
    
}
