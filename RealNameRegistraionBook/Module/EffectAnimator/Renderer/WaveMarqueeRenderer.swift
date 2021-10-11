//
//  WaveMarqueeRenderer.swift
//  EffectAnimator
//
//  Created by Woody on 2021/4/6.
//

import UIKit

open class WaveMqrqueeRenderer: BaseRenderer {
    
    public var text: String? {
        didSet {
            if let text = text {
                setText(text: text)
            }
        }
    }
    
    private var characterString: [Character] = []
    
    public var textColor: UIColor = .black
    
    public var textFont: UIFont = .systemFont(ofSize: 30)
    
    public var direction: DirectionType = .right
    /// 一個畫面波形數量（1 wave = 90 degree)
    public var waveCount: CGFloat = 10
    
    public var waveDirection: WaveDirection = .top

    /// **spacing** 必須大於0
    public var spacing: CGFloat = 0.5
    
    var singleTextBounds: CGRect = .zero
    
    public override func _draw(in ctx: CGContext, _ rect: CGRect, percent: CGFloat) -> CGContext {
        drawText(in: ctx, rect, percent: percent)
        return ctx
    }
    
    func drawText(in ctx: CGContext, _ rect: CGRect, percent: CGFloat) {
        guard let text = text else {
            Logger.log(message: "text is nil")
            return }
        
        if spacing < 0 {
            spacing = 0
        }
        
        let rect = rect.insetBy(dx: 1, dy: singleTextBounds.height / 2)
        
        // x軸 1 xPixel 相對三角函數的角度。
        let xPixelAngle: CGFloat = .pi / 2 * waveCount / rect.width
        
        // let textRect = text.bounds(textFont)
        let textWidth = (singleTextBounds.width + spacing) * CGFloat(text.count) - spacing
        
        // 畫板寬度
        let ctxWidth: CGFloat = rect.width
        // 字串寬度

        // 整個path 的寬度
        let pathWidth = ctxWidth + textWidth
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: textColor, .font: textFont]
        
        let originX: CGFloat
        
        if direction == .right {
            originX = ctxWidth - pathWidth * sin(percent * .pi / 2)
        } else {
            originX = ctxWidth - pathWidth * cos(percent * .pi / 2)
        }
        
        UIGraphicsPushContext(ctx)

        for i in 0..<text.count {
            let string = characterString[i]
            let spacing = i == 0 || i == text.count - 1 ? 0 : self.spacing
            let x = i == 0 ? originX : originX + (singleTextBounds.width * CGFloat(i)) + spacing
            
            let y: CGFloat
            if waveDirection == .top {
                y = (rect.height / 2) * cos((x + singleTextBounds.width) * xPixelAngle) + rect.height / 2
            } else {
                y = (rect.height / 2) * sin((x + singleTextBounds.width) * xPixelAngle) + rect.height / 2
            }
            
            let stringAttribute = NSAttributedString(string: String(string), attributes: attributes)
            stringAttribute.draw(at: CGPoint(x: x, y: y))
        }
        
        UIGraphicsPopContext()
        
    }
    
    
    func setText(text: String) {
        characterString = Array(text)
        let sizes = characterString.map {
            NSString(string: String($0)).boundingRect(with: .zero, options: .usesFontLeading, attributes: [.font: textFont, .foregroundColor: textColor], context: nil)
        }
        sizes.forEach {
            if $0.width > singleTextBounds.width {
                singleTextBounds = $0
            }
        }
    }
    
    
}

extension WaveMqrqueeRenderer {
    public enum DirectionType {
        /// begin at left
        case left
        /// begin at right
        case right
    }
    
    public enum WaveDirection {
        case top
        case down
    }
}
