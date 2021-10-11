//
//  UIView+Animation+Extension.swift
//  iOS_MomDad
//
//  Created by Woody Liu on 2021/5/31.
//

import UIKit


extension UIView {
    
    /// 動畫方向
    enum AnimationDirection {
        case top
        case bottom
        case left
        case right
    }
    
    
    /// self 從 目標 View 的四邊方向顯示出來的動畫。
    /// - Parameters:
    ///   - view: 目標 View
    ///   - direction: 四邊方向
    ///   - duration: 動畫時間
    func displayAnimation(to view: UIView?, direction: AnimationDirection, duration: TimeInterval = 0.3) {
        guard let view = view else { return }
        
        isHidden = true
        let orignAlpha = alpha
        
        alpha = 0
        
        let orignFrmae = frame
        
        var toFrame = frame
        
        switch direction {
        
        case .top:
            let toX = view.frame.origin.y - orignFrmae.height
            toFrame.origin.y = toX
        case .bottom:
            let toY = view.frame.maxY
            toFrame.origin.y = toY
        case .left:
            let toX = view.frame.origin.x - orignFrmae.width
            toFrame.origin.x = toX
        case .right:
            let toX = view.frame.maxX
            toFrame.origin.x = toX
        }
        
        frame = toFrame
        isHidden = false
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.alpha = orignAlpha
        }, completion: nil)
        
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            self.frame = orignFrmae
        }, completion: nil)
        
    }
    
    
    
    ///  self 從 目標 View 的四邊方向，離開 。用於隱藏使用
    /// - Parameters:
    ///   - view: 目標View
    ///   - direction:  目標四邊方向
    ///   - duration:  動畫時間
    ///   - isHiddenOfFinished:  結束後是否 hidden
    func disMissAnimation(to view: UIView?, direction: AnimationDirection, duration: TimeInterval = 0.3, isHiddenOfFinished: Bool) {
        guard let view = view else { return }

        
        isHidden = false
        
        let orignAlpha = alpha
        
        let orignFrmae = frame
        
        var toFrame = frame
        
        switch direction {
        
        case .top:
            let toX = view.frame.origin.y - orignFrmae.height
            toFrame.origin.y = toX
        case .bottom:
            let toY = view.frame.maxY
            toFrame.origin.y = toY
        case .left:
            let toX = view.frame.origin.x - orignFrmae.width
            toFrame.origin.x = toX
        case .right:
            let toX = view.frame.maxX
            toFrame.origin.x = toX
        }
        
        if isHiddenOfFinished {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration + 0.3, delay: 0, options: .curveLinear, animations: {
                self.alpha = 0
            }, completion: nil)
        }
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            self.frame = toFrame
        }, completion: { position in
            
            if position == .end {
                self.isHidden = isHiddenOfFinished
                self.alpha = orignAlpha
                self.frame = orignFrmae
            }
        })
    }
    
    
}
