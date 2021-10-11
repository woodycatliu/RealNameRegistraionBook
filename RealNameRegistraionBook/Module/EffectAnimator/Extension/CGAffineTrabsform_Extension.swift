//
//  CGAffineTrabsform_Extension.swift
//  EffectAnimator
//
//  Created by Woody Liu on 2021/4/19.
//

import UIKit


extension CGAffineTransform {
    
    static func rotate(at center: CGPoint, _ by: CGFloat)-> CGAffineTransform {
        return CGAffineTransform(translationX: center.x, y: center.y).rotated(by: by).translatedBy(x: -center.x, y: -center.y)
    }
    
    
    /// 對圓心 center  x 縮放
    ///  x : y = -1 鏡像效果
    /// - Parameters:
    ///   - center: 鏡像目標
    ///   - x: x  縮放程度
    ///   - y: y  縮放程度
    /// - Returns: CGAffineTransform
    static func sclae(at center: CGPoint, x: CGFloat, y: CGFloat)-> CGAffineTransform {
       return CGAffineTransform(translationX: center.x, y: center.y).scaledBy(x: x, y: y).translatedBy(x: -center.x, y: -center.y)
    }
    
    
}
