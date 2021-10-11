//
//  SMSStorageEditMenuView.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/29.
//

import UIKit


class SMSStorageEditMenuView: UIView {
    
    typealias Press = (()->())
    
    struct Color {
        static let white: UIColor = .rgba(rgb: 233, a: 1)
        static let black: UIColor = AppSetting.Color.textDark
    }
    
    private lazy var deleteLabel: UILabel = {
        let lb = UILabel()
        lb.text = "刪除".localized()
        lb.textAlignment = .center
        lb.textColor = Color.white
        lb.font = .systemFont(ofSize: 25, weight: .semibold)
        lb.backgroundColor = .clear
        lb.isUserInteractionEnabled = false
        return lb
    }()
    
    private lazy var moveLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .clear
        lb.text = "搬移".localized()
        lb.textAlignment = .center
        lb.textColor = Color.white
        lb.font = .systemFont(ofSize: 25, weight: .semibold)
        lb.isUserInteractionEnabled = false
        return lb
    }()
    
    var deletePress: Press?
    
    var movePress: Press?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.addArrangedSubview(deleteLabel)
        stackView.addArrangedSubview(moveLabel)
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: .init(width: 0, height: 40))
        let height: CGFloat = (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0) + 40
        withHeight(height)
        backgroundColor = Color.black.withAlphaComponent(0.9)
    }
}


extension SMSStorageEditMenuView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let point = touches.first?.location(in: self) else { return }
        
        if deleteLabel.frame.contains(point) {
            deleteLabel.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            moveLabel.transform = .identity
        }
        
        if moveLabel.frame.contains(point) {
            moveLabel.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            deleteLabel.transform = .identity
        }
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        deleteLabel.transform = .identity
        moveLabel.transform = .identity
        guard let point = touches.first?.location(in: self) else { return }

        if deleteLabel.frame.contains(point) {
            UISelectionFeedbackGenerator().selectionChanged()
            deletePress?()
        }
        
        if moveLabel.frame.contains(point) {
            UISelectionFeedbackGenerator().selectionChanged()
            movePress?()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        deleteLabel.transform = .identity
        moveLabel.transform = .identity
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let point = touches.first?.location(in: self) else { return }

        if deleteLabel.frame.contains(point) {
            deleteLabel.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            moveLabel.transform = .identity
        }
        
        if moveLabel.frame.contains(point) {
            moveLabel.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            deleteLabel.transform = .identity
        }
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
        
    }
}
