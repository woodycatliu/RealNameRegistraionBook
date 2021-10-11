//
//  GroupSelectionTableViewCell.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/30.
//

import UIKit

class GroupSelectionTableViewCell: UITableViewCell {
    struct Color {
        static let textColor: UIColor = AppSetting.Color.textSecondDark
    }
    
    let label: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 19, weight: .bold)
        lb.textAlignment = .left
        lb.textColor = Color.textColor
        lb.text = "這是一個字串"
        return lb
    }()
    
    private let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .rgba(rgb: 239, a: 1)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    private func commonInit() {
        contentView.addSubview(label)
        label.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 24, bottom: 0, right: 0))
        
        let height = label.heightAnchor.constraint(equalToConstant: 50)
        height.priority = .init(999)
        height.isActive = true
        
        contentView.addSubview(underLine)
        underLine.anchor(top: nil, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 0, left: 24, bottom: 0, right: 24), size: .init(width: 0, height: 1))
    }
    
}
