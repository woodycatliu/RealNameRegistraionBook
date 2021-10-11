//
//  BaseRenderer.swift
//  EffectAnimator
//
//  Created by Woody Liu on 2021/4/4.
//

import UIKit

public protocol RendererDelegate: AnyObject {
    func endDawing(identifier: String)
}


public protocol BaseRendererProtocol: AnyObject {
    
    var isEnd: Bool { get set }
    
    var delegate: RendererDelegate? { get set }
    
    var identifier: String { get }
    /// 一次動畫生命週期所需時間
    var duration: Double { get set }
    /// 動畫已執行時間
    var launchedTimeInterval: CFTimeInterval { get set }
    
    var repeatCount: Double { get set }
    
    func draw(in ctx: CGContext, _ rect: CGRect, timeInterval: CFTimeInterval)-> CGContext
    
    func _draw(in ctx: CGContext, _ rect: CGRect, percent: CGFloat)-> CGContext
    
    func timeToPercent()-> CGFloat
    
    func rotate(_ ctx: CGContext, byAngle: CGFloat, center: CGPoint)-> CGAffineTransform
    
    func translateBy(_ ctx: CGContext, dx: CGFloat, dy: CGFloat)-> CGAffineTransform
    
    func scale(_ ctx: CGContext, scaleX: CGFloat, scaleY: CGFloat, originSize: CGSize)-> CGAffineTransform
    
    func afreshAnimator()
}

// MARK: Time Manager
extension BaseRendererProtocol {
    
    public func draw(in ctx: CGContext, _ rect: CGRect, timeInterval: CFTimeInterval)-> CGContext {
        self.launchedTimeInterval += timeInterval

        let precent = timeToPercent()
        
        return _draw(in: ctx, rect, percent: precent)
    }
    
    public func timeToPercent()-> CGFloat {
        
        guard duration > 0 else { return 0.0 }
        
        guard !isEnd else {
            return 1.0
        }
        
        let timestamp = launchedTimeInterval / duration
        
        guard timestamp < repeatCount else {
            isEnd = true
            delegate?.endDawing(identifier: identifier)
            return 1.0
        }
        return CGFloat(timestamp - Double.getInteger(timestamp))
    }
    
    
    public func afreshAnimator() {
        launchedTimeInterval = 0
        isEnd = false
    }
}

// MARK transform Mangager
extension BaseRendererProtocol {
        
    /// 對 center 圓心 旋轉 byAngle 度
    /// - Parameters:
    ///   - byAngle: 旋轉角度，正數順時針
    ///   - center: 旋轉圓心
    /// - Returns: 反回此次 CGAffineTransform 供之後反轉
    public func rotate(_ ctx: CGContext, byAngle: CGFloat, center: CGPoint)-> CGAffineTransform {
        let transform = CGAffineTransform(translationX: center.x, y: center.y)
            .rotated(by: byAngle)
            .translatedBy(x: -center.x, y: -center.y)
        ctx.concatenate(transform)
        return transform
    }
    
    /// - Parameters:
    ///   - dx: x 軸偏移量
    ///   - dy: y 軸偏移量
    /// - Returns: 反回此次 CGAffineTransform 供之後反轉
    public func translateBy(_ ctx: CGContext, dx: CGFloat, dy: CGFloat)-> CGAffineTransform {
        let transform = CGAffineTransform(translationX: dx, y: dy)
        ctx.concatenate(transform)
        return transform
    }
    
    
    /// 如果放大後還有其他行遍需求，建議直接對 CGSize 做形變
    /// - Parameters:
    ///   - scaleX: X 軸係數縮放倍數
    ///   - scaleY: Y 軸係數縮放倍數
    ///   - originSize: 原始尺寸，用來將圖型偏移回視窗視覺原位
    /// - Returns: 反回此次 CGAffineTransform 供之後反轉
    public func scale(_ ctx: CGContext, scaleX: CGFloat, scaleY: CGFloat ,originSize: CGSize)-> CGAffineTransform {
        let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            .translatedBy(x: -originSize.width / scaleX, y: -originSize.height / scaleY)
        return transform
    }
    
    
}



open class BaseRenderer: BaseRendererProtocol {
    
    public var isEnd: Bool = false
    
    public var delegate: RendererDelegate?
    
    public var identifier: String
    
    open var duration: Double
    
    open var launchedTimeInterval: CFTimeInterval = 0
    
    /// 預設無限
    open var repeatCount: Double = .greatestFiniteMagnitude
    
    open func _draw(in ctx: CGContext, _ rect: CGRect, percent: CGFloat) -> CGContext {
        return ctx
    }
    
    public init(duration: Double, identifier: String = "BassRenderer") {
        self.identifier = identifier
        self.duration = duration
    }
    
}
