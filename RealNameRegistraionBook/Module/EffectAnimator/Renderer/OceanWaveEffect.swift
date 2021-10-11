//
//  OceanWaveEffect.swift
//  EffectAnimator
//
//  Created by Woody on 2021/4/6.
//

import UIKit

open class OceanWaveRenderer: BaseRenderer {
    
    public var color: UIColor = .cyan
    
    public var wavePathAlpha: CGFloat = 0.3
    
    public var contentSize: CGSize = .zero
    
    public var isDrawWavePath: Bool = true
    
    public var isDrawWaveStroke: Bool = true
    
    public override func _draw(in ctx: CGContext, _ rect: CGRect, percent: CGFloat) -> CGContext {
        
        UIGraphicsPushContext(ctx)
        
        if isDrawWaveStroke {
            waveStokeDraw(in: ctx, rect, percent: percent)
        }
        if isDrawWaveStroke {
            wavePathDraw(in: ctx, rect, percent: percent)
        }
        UIGraphicsPopContext()
        return ctx
    }
    
    func waveStokeDraw(in ctx: CGContext, _ rect: CGRect, percent: CGFloat) {
        ctx.move(to: CGPoint(x: 0, y: 20))
        var yPosition = 0.0
        for xPosition in 0..<Int(rect.size.width) {
            yPosition = Double(10 * cos((CGFloat(xPosition) / 180  * .pi)  + 2 * .pi * percent) + 20)
            ctx.addLine(to: CGPoint(x: Double(xPosition), y: yPosition))
        }
        color.setStroke()
        ctx.strokePath()
    }
    
    func wavePathDraw(in ctx: CGContext,_ rect: CGRect, percent: CGFloat) {
        ctx.move(to: CGPoint(x: 0, y: 20))
        var yPosition = 0.0
        for xPosition in 0..<Int(rect.size.width) {
            yPosition = Double(10 * cos((CGFloat(xPosition) / 180  * .pi)  + 2 * .pi * percent) + 20)
            
            ctx.addLine(to: CGPoint(x: Double(xPosition), y: yPosition))
        }
        
        ctx.addLine(to: CGPoint(x: rect.width, y: rect.height))
        ctx.addLine(to: CGPoint(x: 0, y: rect.height))
        ctx.addLine(to: CGPoint(x: 0, y: yPosition))
        ctx.setAlpha(wavePathAlpha)
        color.setFill()
        ctx.closePath()
        ctx.fillPath()
        UIGraphicsPopContext()
    }
    
}
