//
//  QRCodeScanerToastView.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/27.
//

import UIKit

class QRCodeScanerToastView: UIView {
    struct Color {
        static let background: UIColor = .init(hex: "F43B86")
        static let shadow: UIColor = .init(hex: "FF95C5")
    }
    
    private let 請勿亂餵: String = "我只吃SMS-QRCode，請勿亂餵食"
    private let 警告: String = "並非 1922 實名簡訊"

    
    private(set) lazy var titleLabel: UILabel = {
       let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: 20)
        lb.textColor = AppSetting.Color.textDark
        lb.textAlignment = .left
        return lb
    }()
    
    private(set) lazy var phoneLabel: UILabel = {
        let lb = UILabel()
        lb.font = .TCSemibold(size: 15)
        lb.textColor = AppSetting.Color.textSecondDark
        return lb
    }()
    
    private(set) lazy var messageLabel: UILabel = {
        let lb = UILabel()
        lb.font = .TCSemibold(size: 14)
        lb.textColor = AppSetting.Color.textSecondDark
        return lb
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func commoninit() {
        layer.cornerRadius = 15
        layer.shadowColor = Color.shadow.cgColor
        layer.shadowOffset = .init(width: 2.5, height: 2.5)
        layer.shadowOpacity = 1
        
        backgroundColor = Color.background
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 5, left: 15, bottom: 0, right: 15), size: .init(width: 0, height: 45))
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        
        addSubview(stackView)
        stackView.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 15, bottom: 13, right: 15))
        
        stackView.addArrangedSubview(phoneLabel)
        stackView.addArrangedSubview(messageLabel)
        let phoneHeight = phoneLabel.heightAnchor.constraint(equalToConstant: 15)
        phoneHeight.priority = .init(rawValue: 999)
        phoneHeight.isActive = true
        
    }
    
    func errorMessage(error: QRCodeDetectError) {
        switch error {
        case .isNotSMS:
            phoneLabel.isHidden = true
            messageLabel.isHidden = true
            titleLabel.text = 請勿亂餵
        case .isNot1922(let content):
            titleLabel.text = 警告
            if let sms = content.first {
                phoneLabel.text = "電話號碼：" + (sms.phoneNumber ?? "")
                messageLabel.text = "內文：" + (sms.message ?? "")
                phoneLabel.isHidden = false
                messageLabel.isHidden = false
            }
        }
        
        UIView.animate(withDuration: 0.5) {
            self.superview?.layoutIfNeeded()
        }
        
    }
    
    func show(isShowing: Bool) {
        self.bottomConstraint?.constant = isShowing ? -15 : 200
        UIView.animate(withDuration: 0.5) {
            self.superview?.layoutIfNeeded()
        }
    }
    
    
    
    
    
}
