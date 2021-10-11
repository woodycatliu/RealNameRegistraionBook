//
//  ShapeDepot.swift
//  EffectAnimator
//
//  Created by Woody Liu on 2021/4/12.
//

import UIKit


open class ShapeBuilder {
    
    open var center: CGPoint
    
    open var origin: CGPoint
    
    open var size: CGSize
    
    private init(center: CGPoint, origin: CGPoint, size: CGSize) {
        self.center = center
        self.origin = origin
        self.size = size
    }
}

extension ShapeBuilder {
    
    static func initCenter(_ origin: CGPoint, size: CGSize)-> CGPoint {
        return CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
    }
    
    static func initOrigin(_ center: CGPoint, size: CGSize)-> CGPoint {
        return CGPoint(x: center.x - size.width / 2 , y: center.y - size.height / 2)
    }
    
    
    public convenience init(center: CGPoint, size: CGSize) {
        let origin = Self.initOrigin(center, size: size)
        self.init(center: center, origin: origin, size: size)
    }
    
    public convenience init(origin: CGPoint, size: CGSize) {
        let center = Self.initCenter(origin, size: size)
        self.init(center: center, origin: origin, size: size)
    }
    
    
}

public protocol Builder: class {
    
    var path: UIBezierPath { get }
    
    var pathPoints: [CGPoint] { get }
    
    func getPoint(_ percent: CGFloat, rotate: CGFloat)-> CGPoint
    
}



