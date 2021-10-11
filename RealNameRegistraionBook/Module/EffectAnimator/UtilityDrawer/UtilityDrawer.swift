//
//  UtilityDrawer.swift
//  EffectAnimator
//
//  Created by Woody Liu on 2021/4/12.
//


/*
 繪圖工具：
 提供各種形狀繪圖功能
 */

import UIKit


class UtilityDrawer {
    
    
    /// 繪製矩形
    /// - Parameters:
    ///   - lineWidth: 寬度，預設為 1。
    ///   - color: 預設 black
    ///   - alpha: 預設 1
    ///   - isStroke: 是否繪製線條
    ///   - isClip: 是否挖空矩形
    static func drawRect(_ ctx: CGContext, rect: CGRect, lineWidth: CGFloat = 1, color: UIColor = .black, alpha: CGFloat = 1, isStroke: Bool, isClip: Bool = false) {
        let path = UIBezierPath(rect: rect)
        draw(ctx, path: path, lineWidth: lineWidth, color: color, alpha: alpha, isStroke: isStroke, isClip: isClip)
    }
    
    
    ///  繪製橢圓形
    /// - Parameters:
    ///   - rect: 傳入正方形，則繪製正圓形
    ///   - lineWidth: 預設 1
    ///   - color: 預設黑色
    ///   - alpha: 預設1
    ///   - isClip: 預設 false
    static func drawOval(_ ctx: CGContext, rect: CGRect, lineWidth: CGFloat = 1, color: UIColor = .black, alpha: CGFloat = 1, isStroke: Bool, isClip: Bool = false) {
        let path = UIBezierPath(ovalIn: rect)
        draw(ctx, path: path, lineWidth: lineWidth, color: color, alpha: alpha, isStroke: isStroke, isClip: isClip)
    }
    
    
    
    /// 繪製連續直線
    /// - Parameters:
    ///   - pathPoint: 依照 pathPoint 順序繪製直線。 pathPoint[0] 為初始點
    ///   - lineWidth: 預設 1
    ///   - color: 預設黑色
    ///   - alpha: 預設1
    ///   - isClip: 預設 false
    static func drawLines(_ ctx: CGContext, pathPoint: [CGPoint], lineWidth: CGFloat = 1, color: UIColor = .black, alpha: CGFloat = 1, isStroke: Bool, isClip: Bool = false) {
        let path = UIBezierPath()
        
        guard !pathPoint.isEmpty else {
            ctx.beginPath()
            return }
        var pathPoint = pathPoint
        let point = pathPoint.removeFirst()
        path.move(to:point)
        
        pathPoint.forEach {
            path.addLine(to: $0)
        }
        
        draw(ctx, path: path, lineWidth: lineWidth, color: color, alpha: alpha, isStroke: isStroke, isClip: isClip)
    }

    
    
    
    static func draw(_ ctx: CGContext, path: UIBezierPath, lineWidth: CGFloat = 1, color: UIColor = .black, alpha: CGFloat = 1, isStroke: Bool, isClip: Bool = false) {
        _draw(ctx, path: path, color: color, alpha: alpha, isStroke: isStroke, isClip: isClip)
    }
    
    
    static private func _draw(_ ctx: CGContext, path: UIBezierPath, lineWidth: CGFloat = 1, color: UIColor, alpha: CGFloat, isStroke: Bool, isClip: Bool) {
        path.lineWidth = lineWidth
        
        ctx.addPath(path.cgPath)
        
        ctx.setAlpha(alpha)
        
        
        if isClip {
            ctx.clip()
            return
        }
        
        if isStroke {
            color.setStroke()
            ctx.strokePath()
            return
        }
        
        color.setFill()
        ctx.fillPath()
        
    }
    
}



