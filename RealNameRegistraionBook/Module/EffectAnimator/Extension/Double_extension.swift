//
//  Double_extension.swift
//  EffectAnimator
//
//  Created by Woody on 2021/4/6.
//

import Foundation
import UIKit

extension Double {
    static func getDecimal(_ dividend: Double, _ divisor: Double)-> Double {
        return dividend / divisor - Double(Int(dividend / divisor))
    }
    
    static func getInteger(_ value: Double)-> Double {
        return Double(Int(value))
    }
    
    var percentage: Double {
        return self - Double(Int(self))
    }
}


extension CGFloat {
    static func getDecimal(_ dividend: CGFloat, _ divisor: CGFloat)-> CGFloat {
        return dividend / divisor - CGFloat(Int(dividend / divisor))
    }
    
    static func getInteger(_ value: CGFloat)-> CGFloat {
        return CGFloat(Int(value))
    }
    
    var percentage: CGFloat {
        return self - CGFloat(Int(self))
    }
}
