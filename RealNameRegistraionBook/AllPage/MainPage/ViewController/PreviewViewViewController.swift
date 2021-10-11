//
//  PreviewViewViewController.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/30.
//

import UIKit

class PreviewViewViewController: UIViewController {
    
    private let cardView: UIView = UIView()
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 25, weight: .bold)
        lb.numberOfLines = 2
        lb.textAlignment = .left
        lb.textColor = AppSetting.Color.textDark
        return lb
    }()
    
    private let contentLabel:  UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 23, weight: .regular)
        lb.numberOfLines = 0
        lb.textAlignment = .left
        lb.textColor = AppSetting.Color.textSecondDark
        return lb
    }()
    
    let place: RealNamePlace
    
    init(place: RealNamePlace, color: UIColor) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .clear
        cardView.addSubview(titleLabel)
        
        titleLabel.anchor(top: cardView.topAnchor, leading: cardView.leadingAnchor, bottom: nil, trailing: cardView.trailingAnchor, padding: .init(top: 10, left: 15, bottom: 0, right: 15))
        
        cardView.addSubview(contentLabel)
        contentLabel.anchor(top: titleLabel.bottomAnchor, leading: cardView.leadingAnchor, bottom: nil, trailing: cardView.trailingAnchor, padding: .init(top: 10, left: 15, bottom: 10, right: 15))
        contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -10).isActive = true
        
        view.addSubview(cardView)
        cardView.fillSuperview()
        cardView.backgroundColor = color
        
        let width = view.bounds.width
        let height = width * 4 / 7
        
        titleLabel.text = (place.name ?? "尚未命名".localized())
        contentLabel.text = place.message
        
        preferredContentSize = CGSize(width: width, height: height)
        overrideUserInterfaceStyle = .dark
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
