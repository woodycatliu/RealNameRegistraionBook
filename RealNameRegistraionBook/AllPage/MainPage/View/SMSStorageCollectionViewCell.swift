//
//  SMSStorageCollectionViewCell.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/29.
//

import UIKit
import Combine

class SMSStorageCollectionViewCell: UICollectionViewCell {
    
    struct Color {
        static let white: UIColor = .rgba(rgb: 245, a: 1)
        static let textColor: UIColor = AppSetting.Color.textDark
        static let secondTextColor: UIColor = AppSetting.Color.textSecondDark
    }
    
    private var anyCancellables = Set<AnyCancellable>()
    
    weak var viewModel: SMSStorageCellViewModel? {
        didSet {
            anyCancellables.removeAll()
            
            viewModel?.$pettern
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.iconView.isHidden = !($0 == .selection)
                    self?.startAnimation(isStart: $0 == .selection)
                }
                .store(in: &anyCancellables)
            
            
            viewModel?.$selectionCache
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self = self,
                          let viewModel = self.viewModel else { return }
                    let isSelected = viewModel.isSelected(indexPath: self.indexPath)
                    self.iconView.setSelection(isSeleceted: isSelected)
                }
                .store(in: &anyCancellables)
        }
    }
    
    var indexPath: IndexPath?
    
    let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = SMSStorageCollectionViewCell.Color.textColor
        lb.font = .systemFont(ofSize: 18, weight: .heavy)
        lb.numberOfLines = 2
        return lb
    }()
    
    private(set) lazy var contentLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = SMSStorageCollectionViewCell.Color.secondTextColor
        lb.font = .systemFont(ofSize: 14, weight: .light)
        lb.numberOfLines = 1
        return lb
    }()
    
    private(set) lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = .init(systemName: "message.fill")?.imgWithNewSize(size: .init(width: 30, height: 40))?.tinted(color: SMSStorageCollectionViewCell.Color.white)
        return iv
    }()
    
    private let iconView: IconView = IconView()
    
    private var isLaunchTouchAnimator: Bool = false
    
    override var isHighlighted: Bool {
        didSet {
            guard isLaunchTouchAnimator else { return }
            if oldValue != isHighlighted {
                let transform: CGAffineTransform = isHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : CGAffineTransform(scaleX: 1, y: 1)
                self.cardView.transform = transform
                UIView.animate(withDuration: 0.3) {
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isLaunchTouchAnimator = true
    }
    
}

// MARK: layout ui
extension SMSStorageCollectionViewCell {
    
    private func commonInit() {
        backgroundColor = .clear
        contentView.addSubview(cardView)
        cardView.fillSuperview()
        
        cardView.addSubview(imageView)
        imageView.withSize(.init(width: 24, height: 24))
        imageView.anchor(top: cardView.topAnchor, leading: cardView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10, left: 14, bottom: 0, right: 0))
        
        cardView.addSubview(contentLabel)
        contentLabel.anchor(top: nil, leading: cardView.leadingAnchor, bottom: cardView.bottomAnchor, trailing: cardView.trailingAnchor, padding: .init(top: 0, left: 14, bottom: 13, right: 14))
        
        cardView.addSubview(titleLabel)
        titleLabel.anchor(top: nil, leading: cardView.leadingAnchor, bottom: contentLabel.topAnchor, trailing: cardView.trailingAnchor, padding: .init(top: 0, left: 14, bottom: 0, right: 14))
        
        titleLabel.topAnchor.constraint(greaterThanOrEqualTo: imageView.bottomAnchor, constant: 4).isActive = true
        
        cardView.addSubview(iconView)
        iconView.anchor(top: cardView.topAnchor, leading: nil, bottom: nil, trailing: cardView.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 10))
        
    }
}


extension SMSStorageCollectionViewCell {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let point = touches.first?.location(in: self), cardView.frame.contains(point) else { return }
        isHighlighted = false
        isHighlighted = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isHighlighted = false
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isHighlighted = false
        cardView.transform = .identity
    }
    
}

extension SMSStorageCollectionViewCell {
    
   private func startAnimation(isStart: Bool) {
        if isStart {
            shakeAnimation()
            return
        }
        removeShake()
    }
    
    private func shakeAnimation() {
        self.cardView.layer.removeAnimation(forKey: "transform.rotation")
        let keyAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        keyAnimation.duration = 0.3
        keyAnimation.beginTime = CACurrentMediaTime()
        keyAnimation.values = [-Double.pi / 50, Double.pi / 50, -Double.pi / 50]
        keyAnimation.repeatCount = .greatestFiniteMagnitude
        keyAnimation.isRemovedOnCompletion = true
        self.cardView.layer.add(keyAnimation, forKey: "transform.rotation")
    }
    
    private func removeShake() {
        self.cardView.layer.removeAnimation(forKey: "transform.rotation")
    }
    
}


extension SMSStorageCollectionViewCell {
    
    class IconView: UIView {
        
        struct Color {
            static let blue: UIColor = .init(hex: "00A8CC")
        }
        
        private(set) lazy var imageView: UIImageView = {
            let iv = UIImageView()
            iv.image = nil
            return iv
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func commonInit() {
            layer.cornerRadius = 11.5
            backgroundColor = .rgba(rgb: 255, a: 1)
            withSize(.init(width: 23, height: 23))
            addSubview(imageView)
            imageView.fillSuperview(padding: .init(top: 1, left: 1, bottom: 1, right: 1))
        }
        
        func setSelection(isSeleceted: Bool) {
            imageView.image = isSeleceted ? .init(systemName: "checkmark.circle.fill")?.imgWithNewSize(size: .init(width: 22, height: 22))?.tinted(color: Color.blue) : nil
        }
        
    }
    
    
}
