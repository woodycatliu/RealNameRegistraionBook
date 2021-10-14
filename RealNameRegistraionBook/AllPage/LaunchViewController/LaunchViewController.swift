//
//  LaunchViewController.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/10/1.
//

import UIKit


class LaunchViewController: UIViewController {
    static let fontName: String = "Marker Felt"
    
    private let label1922 = Label1922()
    private let labelMessage = LabelMessage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        label1922.animate()
        labelMessage.animate()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.launchedFinished()
        }
        
    }
    
    
    private func configure() {
        view.backgroundColor = AppSetting.Color.white
        view.addSubview(label1922)
        label1922.centerYTo(view.centerYAnchor, constant: -50)
        label1922.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 200))
        view.addSubview(labelMessage)
        labelMessage.centerXTo(label1922.label.trailingAnchor, constant: -10)
        labelMessage.topConstraint = labelMessage.topAnchor.constraint(equalTo: label1922.label.bottomAnchor, constant: view.bounds.height)
        labelMessage.topConstraint?.isActive = true
    }
    
    private func launchedFinished() {
        Router.shared.initMainApplication()
    }
    
}

class Label1922: UIView {
    
    let label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        commonInit()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        label.font = UIFont(name: LaunchViewController.fontName, size: 80)
        label.text = "1922"
        label.textColor = AppSetting.Color.textDark
        label.layer.borderColor = AppSetting.Color.textDark.cgColor
        label.layer.borderWidth = 2
    }
    
    private func commonInit() {
        addSubview(label)
        label.alpha = 0
        label.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil)
        label.centerXTo(centerXAnchor, constant: -55)
    }
    
    func animate() {
        UIView.animate(withDuration: 0.2, animations: {
            self.label.alpha = 1
        } , completion: { bool in
            if bool {
                self.rorate()
            }
        })
        
    }
    private func rorate() {
        UIView.animate(withDuration: 0.25, delay: 0.015, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, animations: {
            self.label.transform = CGAffineTransform.init(rotationAngle: -.pi / 5)
        }, completion: { bool in
            if bool {
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveEaseInOut, animations: {
                    self.label.transform = CGAffineTransform.init(rotationAngle: -.pi / 7)
                }, completion: nil)
            }
        })
    }
    
}

class LabelMessage: UIView {
    
    var topConstraint: NSLayoutConstraint?
    
    let label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addSubview(label)
        label.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        label.font = UIFont(name: LaunchViewController.fontName, size: 70)
        label.text = "SMS"
        label.textColor = AppSetting.Color.textDark
    }
    
    
    func animate() {
        UIView.animate(withDuration: 0.05, delay: 0.025, animations: {
            self.topConstraint?.constant = -30
            self.superview?.layoutIfNeeded()
        }, completion: { bool in
            if bool {
                let orign = self.frame
                self.layer.anchorPoint = .init(x: 0.5, y: 0)
                self.frame = orign
                UIView.animate(withDuration: 0.0625, delay: 0, animations: {
                    self.transform = CGAffineTransform(scaleX: 1, y: 0.5)
                }, completion: { bool in
                    if bool {
                        UIView.animate(withDuration: 0.1, animations: {
                            self.transform = .identity
                        })
                    }
                })
            }
        })
        
    }
}
