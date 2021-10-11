//
//  AddNewHeaderView.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/30.
//

import UIKit

class AddNewHeaderView: UITableViewHeaderFooterView {
    
    struct Color {
        static let highlightedColor: UIColor = .rgba(rgb: 248, a: 1)
        static let gray: UIColor = .rgba(rgb: 239, a: 1)
    }
    
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = .init(systemName: "plus.rectangle.fill.on.folder.fill")?.tinted(color: AppSetting.Color.mainBlue)
        iv.highlightedImage = .init(systemName: "plus.rectangle.fill.on.folder.fill")?.tinted(color: Color.highlightedColor)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let label: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 20, weight: .heavy)
        lb.textColor = AppSetting.Color.textDark
        lb.textAlignment = .left
        lb.text = "新增資料夾".localized()
        return lb
    }()
    
    private let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = Color.gray
        return view
    }()
    
    var tapPress: (()->())?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView?.backgroundColor = .rgba(rgb: 255, a: 1)
    }
    
    
    private func commonInit() {
        contentView.backgroundColor = .rgba(rgb: 255, a: 1)
        contentView.addSubview(imageView)
        imageView.anchor(top: nil, leading: contentView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 0), size: .init(width: 40, height: 30))
        
        imageView.centerYTo(contentView.centerYAnchor)
        
        contentView.addSubview(label)
        label.anchor(top: contentView.topAnchor, leading: imageView.trailingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 15))
        
        let height = label.heightAnchor.constraint(equalToConstant: 60)
        height.priority = .init(999)
        height.isActive = true
        
        contentView.addSubview(underLine)
        underLine.anchor(top: nil, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 0, left: 24, bottom: 0, right: 24), size: .init(width: 0, height: 1))
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(gesture))
        tap.cancelsTouchesInView = false
        
        contentView.addGestureRecognizer(tap)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        imageView.isHighlighted = true
        label.textColor = .rgba(rgb: 233, a: 1)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        imageView.isHighlighted = false
        label.textColor = .rgba(rgb: 29, a: 1)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        imageView.isHighlighted = false
        label.textColor = .rgba(rgb: 29, a: 1)
    }
}


// MARK: objc
extension AddNewHeaderView {
    
    @objc
    private func gesture() {
        tapPress?()
    }
}
