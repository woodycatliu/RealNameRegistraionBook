//
//  RhombusBuilder.swift
//  EffectAnimator
//
//  Created by Woody Liu on 2021/4/19.
//

import UIKit


final public class RhombusBuilder: ShapeBuilder, Builder {
    
    public var path: UIBezierPath {
        let bezier = UIBezierPath()
        let left: CGPoint = CGPoint(x: center.x - size.width / 2, y: center.y)
        let top = CGPoint(x: center.x, y: center.y - size.height / 2)
        let right = CGPoint(x: center.x + size.width / 2, y: center.y)
        let bottom = CGPoint(x: center.x, y: center.y + size.height / 2)
        
        bezier.move(to: left)
        bezier.addLine(to: top)
        bezier.addLine(to: right)
        bezier.addLine(to: bottom)
        bezier.close()
        
        return bezier
    }
    
    public var pathPoints: [CGPoint] {
        
        var pathPoints: [CGPoint] = []
        let m =  size.height / size.width

        for i in 0...100 {
            let width: CGFloat = size.width / 2 * CGFloat(i) / 100
            let height: CGFloat = width * m
            pathPoints.append(CGPoint(x: center.x - size.width / 2 + width, y: center.y - height))
        }
        
        // 做兩次鏡像算出菱形四個點位
        let p1 = pathPoints
            p1.forEach {
                // 對 圓心Y軸做鏡像
                // 匯出上半部點位
                let trans = CGAffineTransform.sclae(at: center, x: -1, y: 1)
                let np = $0.applying(trans)
                pathPoints.append(np)
            }
        let p2 = pathPoints
        p2.forEach {
            // 對 圓心X軸做鏡像
            // 匯出下半部點位
            let trans = CGAffineTransform.sclae(at: center, x: 1, y: -1)
            let np = $0.applying(trans)
            pathPoints.append(np)
        }
        
        return pathPoints
    }
    
    
    public func getPoint(_ percent: CGFloat, rotate: CGFloat) -> CGPoint {
        
        // 圖型完成度百分比
        // percentage: 取小數
        var percent = percent.percentage
        
        // axis-X 的乘數
        var mutiX: CGFloat = 0

        // axis-Y 的乘數
        var mutiY: CGFloat = 0
        
        // 斜率
        let m: CGFloat = size.height / size.width
        
        // 回傳值
        var p: CGPoint = .zero
            
        // 菱形對圓心 第二象限邊的點位
        if (percent >= 0 && percent <= 0.25) || (percent >= -1 && percent <= -0.75) {
            
            percent = (percent >= 0 && percent <= 0.25) ? percent / 0.25 : abs((percent + 1) / 0.25)
           
            mutiX = 1

            mutiY = -1
                        
            p = CGPoint(x: center.x - size.width / 2, y: center.y)
        }
        // 菱形對圓心 第一象限邊的點位
        else if (percent >= 0.25 && percent <= 0.50) || (percent >= -0.75 && percent <= -0.50) {
            
            mutiX = 1
            
            mutiY = 1
            
            p = CGPoint(x: center.x, y: center.y - size.height / 2)
            
            percent = (percent >= 0.25 && percent <= 0.50) ? (percent - 0.25) / 0.25 : abs((percent + 0.75) / 0.25)
            
        }
        // 菱形對圓心 第三象限邊的點位
        else if (percent >= 0.50 && percent <= 0.75) || (percent >= -0.50 && percent <= -0.25) {
            
            mutiX = -1
            
            mutiY = 1
            
            p = CGPoint(x: center.x + size.width / 2, y: center.y)
            
            percent = (percent >= 0.50 && percent <= 0.75) ? (percent - 0.5) / 0.25 : abs((percent + 0.50) / 0.25)
            
            
        }
        // 菱形對圓心 第四象限邊的點位
        else if (percent >= 0.75 && percent <= 1) || (percent >= -0.25 && percent <= 0) {
            
            mutiX = -1
            
            mutiY = -1
            
            p = CGPoint(x: center.x, y: center.y + size.height / 2)
            
            percent = (percent >= 0.75 && percent <= 1) ? (percent - 0.75) / 0.25 : abs((percent + 0.25) / 0.25)

        }
        
        // 依照圖形百分比取得寬度
        let width: CGFloat = abs(size.width / 2 * percent)
        
        // height = width * m
        // 高 = 寬 * 斜率
        let height: CGFloat = width * m
        
        // 旋轉矩陣
        let trans = CGAffineTransform.rotate(at: center, rotate)
        
        return CGPoint(x: p.x + width * mutiX, y: p.y + mutiY * height).applying(trans)
        
    }
    
    
    
    
}



