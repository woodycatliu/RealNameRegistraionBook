//
//  GroupSelectionTopView.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/30.
//

import UIKit

class GroupSelectionTopView: UIView {

    let button: UIButton = {
        let btn = UIButton()
        btn.setTitle("取消".localized(), for: .normal)
        btn.setTitle("取消".localized(), for: .highlighted)
        btn.setTitleColor(AppSetting.Color.mainBlue, for: .normal)
        btn.setTitleColor(.rgba(rgb: 244, a: 1), for: .highlighted)
        btn.titleLabel?.textAlignment = .left
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        return btn
    }()
    
    let label: UILabel = {
        let lb = UILabel()
        lb.text = "選擇資料夾".localized()
        lb.textAlignment = .center
        lb.textColor = .rgba(rgb: 29, a: 1)
        lb.font = .systemFont(ofSize: 17, weight: .black)
        return lb
    }()
    
    private let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .rgba(rgb: 239, a: 1)
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func commonInit() {
        backgroundColor = .rgba(rgb: 255, a: 1)
        layer.cornerRadius = .adjustFloat(min: 22, max: 24)
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true
                
        let height = heightAnchor.constraint(equalToConstant: .adjustFloat(min: 52, max: 57.5))
        height.priority = .init(999)
        height.isActive = true
        
        addSubview(button)
        button.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: .adjustFloat(min: 24, max: 30), bottom: .adjustFloat(min: 11, max: 12.5), right: 0), size: .init(width: 50, height: 30))
        
        addSubview(label)
        label.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 24 + 30 + 3, bottom: .adjustFloat(min: 11, max: 12.5), right: 24 + 30 + 3))
        
        button.centerYTo(label.centerYAnchor)
        
        addSubview(underLine)
        underLine.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 24, bottom: 0, right: 24), size: .init(width: 0, height: 1))
        
    }
    
    
}
