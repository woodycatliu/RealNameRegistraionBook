//
//  String_Extension.swift
//  EffectAnimator
//
//  Created by Woody on 2021/4/6.
//

import UIKit

extension String {
    func bounds(_ textFont: UIFont)-> CGRect {
        NSString(string: self).boundingRect(with: .zero, options: .usesFontLeading, attributes: [.font: textFont], context: nil)
    }
}
