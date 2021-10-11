//
//  ToastAlertView.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/29.
//

import UIKit

class ToastAlertView: UIView {
            
    lazy var label: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 14, weight: .regular)
        lb.textAlignment = .left
        lb.textColor = .rgba(rgb: 255, a: 1)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
                
        withHeight(45)
        withWidth(UIScreen.main.bounds.width - 48)
        
        layer.cornerRadius = 22.5
        layer.backgroundColor = UIColor.rgba(rgb: 29, a: 0.6).cgColor
        
        addSubview(label)
        label.fillSuperview(padding: .init(top: 0, left: 22, bottom: 0, right: 22))

        isHidden = true
        alpha = 0

    }
    
    private var hiddenAnimator: UIViewPropertyAnimator?
    
    
    func show(message: String) {
        guard isHidden else {
            hiddenAnimator?.stopAnimation(true)
            alpha = 0
            isHidden = true
            show(message: message)
            return
        }
        label.text = message
        translatesAutoresizingMaskIntoConstraints = true
        alpha = 0.1
        isHidden = false
        showAlert()
        hidden()
    }
    
    
    private func showAlert() {

        let animaotion = {
            self.alpha = 1
        }
        
        UIView.animate(withDuration: 0.5, animations: animaotion)
     
    }
    
    
    private func hidden() {
        hiddenAnimator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 2.3, options: .curveEaseIn, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.isHidden = true
        })
    }
    
    
}
