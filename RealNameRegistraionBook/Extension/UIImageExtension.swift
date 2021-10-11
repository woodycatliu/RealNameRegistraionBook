//
//  UIImageExtension.swift
//  IOS_Costco
//
//  Created by cm0637 on 2020/8/6.
//  Copyright © 2020 CMoney. All rights reserved.
//

import UIKit

extension UIImage {
    func tinted(color: UIColor) -> UIImage? {
        let image = withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color

        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            imageView.layer.render(in: context)
            let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return tintedImage
        } else {
            return self
        }
    }
    
    /// 利用顏色init圖片
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
      let rect = CGRect(origin: .zero, size: size)
      UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
      color.setFill()
      UIRectFill(rect)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
}


extension UIImage {
    
    /// 壓縮img 至指定大小
    /// - Parameter MB: 預設1
    /// - Returns: 已壓縮 Data
    public func compressImgMid(KB: Int = 1)-> Data? {
        let maxLength = KB * 1024
        var compression: CGFloat = 1
        
        guard var data = self.jpegData(compressionQuality: compression) else {
            Logger.log(message: "壓縮失敗")
            return nil
        }
        Logger.log(message: "原始kb: \(Double(data.count / 1024)) kb")
        if data.count < maxLength { return data }
        
        var max: CGFloat = 1
        var min: CGFloat = 0
        
        for i in 0..<6 {
            compression = (max + min) / 2
            
            guard let newData = self.jpegData(compressionQuality: compression) else {
                Logger.log(message: "第\(i)次壓縮失敗")
                return data
            }
            
            Logger.log(message: "第\(i)次壓縮: \(Double(newData.count / 1024)) kb")
            data = newData
            
            if CGFloat(newData.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        
        return data
    }
    
    /// 圖片尺寸
    /// - Parameter size: 預設為螢幕 1/3
    /// - Returns: UIImage?
    public func imgWithNewSize(size: CGSize = CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3))-> UIImage? {
        
        var newSize = size
        
        if self.size.height > size.height {
            newSize.width = size.height / self.size.height * self.size.width
        }
        
        UIGraphicsBeginImageContext(newSize)
        
        self.draw(in: CGRect(origin: .zero, size: newSize))
        
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImg
        
    }
    
}
