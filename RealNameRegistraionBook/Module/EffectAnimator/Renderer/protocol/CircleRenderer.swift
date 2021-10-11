//
//  CircleRenderer.swift
//  iOS_MomDad
//
//  Created by Woody Liu on 2021/6/10.
//

import UIKit
import Combine

class CircleRenderer: BaseRendererProtocol {
    
    @Published
    private(set) var endPoint: CGPoint = .zero
    
    var isEnd: Bool = false

    weak var delegate: RendererDelegate?
    
    var identifier: String
    
    var duration: Double = 30.0
    
    var launchedTimeInterval: CFTimeInterval = 0.0
    
    var repeatCount: Double = 1
    
    var lineWidth: CGFloat = 28
    
    var color: UIColor = .pink
    
    var concentricCircleColor: UIColor = .rgba(rgb: 235, a: 1)
    
    func _draw(in ctx: CGContext, _ rect: CGRect, percent: CGFloat) -> CGContext {
        
        lineWidth = 28 / 140 * rect.height
        
        let center: CGPoint = .init(x: rect.width / 2, y: rect.height / 2)
        
        let endAgnle: CGFloat = .pi + .pi / 2 + 2 * .pi * percent
        
        ctx.addArc(center: center, radius: rect.height / 2 - lineWidth / 2, startAngle: 0, endAngle: .pi * 2, clockwise: false)
        concentricCircleColor.setFill()
        ctx.drawPath(using: .fill)
        

        ctx.setLineWidth(lineWidth)
        ctx.addArc(center: center, radius: rect.height / 2, startAngle: .pi + .pi / 2, endAngle: endAgnle, clockwise: false)
        color.setStroke()
        
        ctx.drawPath(using: .stroke)
        
        updateEndPoint(rect: rect, center: center, percent: percent)
        
        return ctx
    }
    
    init(duration: Double, identifier: String = "DrawCircle") {
        self.duration = duration
        self.identifier = identifier
    }
    
    
    private func updateEndPoint(rect: CGRect, center: CGPoint, percent: CGFloat) {
        var starCenter: CGPoint = center.applying(CGAffineTransform.init(translationX: 0, y: -(rect.height / 2 - lineWidth / 4)))
        
        let startAngle: CGFloat = .pi + .pi / 2
        
        let endAgnle: CGFloat = .pi + .pi / 2 + 2 * .pi * percent
    
        let transform: CGAffineTransform = CGAffineTransform(translationX: center.x, y: center.y)
            .rotated(by: endAgnle - startAngle)
            .translatedBy(x: -center.x, y: -center.y)
        
        starCenter = starCenter.applying(transform)
        
        endPoint = starCenter
        
    }
    

    
}
