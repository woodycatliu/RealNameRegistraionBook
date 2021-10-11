//
//  StringExtension.swift
//  iOS_MomDad
//
//  Created by Woody Liu on 2021/5/31.
//

import Foundation
import UIKit

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last ?? ""
    }
    
    func substring(_ from: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: from)])
    }
    
    var length: Int {
        return self.count
    }
    
    var isBlank: Bool {
        for character in self where !character.isWhitespace {
            return false
        }
        return true
    }
}


extension String {
    
    func localized(with comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
}


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    var removeHtmalTag: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}


extension String {
    
    func lineSpacing(_ value: CGFloat, font: UIFont)-> NSAttributedString {
        //设置行间距
        let paraph = NSMutableParagraphStyle()
        //将行间距
        paraph.lineSpacing = value
        
        let attributes = [NSAttributedString.Key.font: font,
                          NSAttributedString.Key.paragraphStyle: paraph]
        return NSAttributedString(string: self, attributes: attributes)
    }
    
}
