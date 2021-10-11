//
//  SMSStorageHeaderView.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/29.
//

import UIKit
import Combine

protocol SMSStorageHeaderViewDelegate: AnyObject {
    func didTapHeader(headerView: SMSStorageHeaderView, indexPath: IndexPath?)
}

class SMSStorageHeaderView: UICollectionReusableView {
    struct Color {
        static let background: UIColor = .init(hex: "DEEDF0")
    }
    
    enum CheckMarkStats {
        case checking
        case non
        
        var image: UIImage? {
            switch self {
            case .checking:
                return .init(systemName: "checkmark.square")?.imgWithNewSize(size: .init(width: 25, height: 25))?.tinted(color: AppSetting.Color.textDark)
            case .non:
                return .init(systemName: "square")?.imgWithNewSize(size: .init(width: 25, height: 25))?.tinted(color: .rgba(rgb: 222, a: 1))
            }
        }
    }
    
    weak var delegate: SMSStorageHeaderViewDelegate?
    
    private var anyCancellables = Set<AnyCancellable>()
    
    var indexPath: IndexPath?
    
    weak var viewModel: SMSStorageCellViewModel? {
        didSet {
            anyCancellables.removeAll()
            
            viewModel?.$pettern
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in
                    self?.rightBtn.isHidden = !($0 == .selection)
                }.store(in: &anyCancellables)
            
            viewModel?.$selectedAllCache
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    guard let self = self,
                          let viewModel = self.viewModel,
                          let indexPath = self.indexPath else { return }
                    let isSelectedAll = viewModel.isSelectedAll(section: indexPath.section)
                    self.isSelectAll(isSelected: isSelectedAll)
                }.store(in: &anyCancellables)
        }
    }
    
    lazy var imageView: UIImageView = {
       let iv = UIImageView()
        iv.image = .init(systemName: "arrowtriangle.right.fill")?.imgWithNewSize(size: .init(width: 30, height: 30))?.tinted(color: AppSetting.Color.textDark)
        return iv
    }()
    
    lazy var label: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 25, weight: .heavy)
        lb.textColor = AppSetting.Color.textDark
        lb.textAlignment = .left
        return lb
    }()
    
    lazy var rightBtn: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .center
        btn.setImage(CheckMarkStats.non.image, for: .normal)
        btn.setImage(CheckMarkStats.non.image, for: .highlighted)
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
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
    
    override func prepareForReuse() {
        anyCancellables.removeAll()
        indexPath = nil
        viewModel = nil
        isSelectAll(isSelected: false)
        super.prepareForReuse()
    }
    
    private var isLaunchTouchAnimator: Bool = false

    var isHighlighted: Bool = false {
        didSet {
            guard isLaunchTouchAnimator else { return }
            if oldValue != isHighlighted {
                let fonSize: CGFloat = isHighlighted ? 22 : 25
                label.font = .systemFont(ofSize: fonSize, weight: .heavy)
            }
        }
    }
    
    private func commonInit() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(headerAction))
        addGestureRecognizer(tap)
        
        backgroundColor = Color.background
        
        addSubview(imageView)
        imageView.centerYTo(centerYAnchor)
        imageView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 18, bottom: 0, right: 0), size: .init(width: 20, height: 20))
        
        addSubview(label)
        label.anchor(top: nil, leading: imageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 5, left: 5, bottom: 5, right: 0), size: .init(width: 0, height: 30))
        label.centerYTo(centerYAnchor)

        addSubview(rightBtn)
        rightBtn.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 15), size: .init(width: 45, height: 45))
        rightBtn.centerYTo(centerYAnchor)
        
        let line = UIView()
        addSubview(line)
        line.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 0.8))
        line.backgroundColor = AppSetting.Color.darkBlue
        
        layer.borderColor = AppSetting.Color.darkBlue.withAlphaComponent(0.8).cgColor
        layer.borderWidth = 0.4
    }
    
}

// MARK: logic
extension SMSStorageHeaderView {
   
    func sectionIsOpening(_ isOpening: Bool) {
        let transform: CGAffineTransform = isOpening ? CGAffineTransform(rotationAngle: .pi / 2) : .identity
        imageView.transform = transform
    }
    
    func isSelectAll(isSelected: Bool) {
        let checkingType: CheckMarkStats = isSelected ? .checking : .non
        rightBtn.setImage(checkingType.image, for: .normal)
        rightBtn.setImage(checkingType.image, for: .highlighted)
    }
    
}

// MARK: objc
extension SMSStorageHeaderView {
    
    @objc
    private func btnAction() {
        guard let viewModel = viewModel,
              let section = indexPath?.section else { return }
        if viewModel.isSelectedAll(section: section) {
            viewModel.removedSelectedAll(section: section)
            return
        }
        viewModel.selectedAll(section: section)
    }
    
    @objc
    private func headerAction() {
        delegate?.didTapHeader(headerView: self, indexPath: indexPath)
    }
}

extension SMSStorageHeaderView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let point = touches.first?.location(in: self), self.bounds.contains(point) else { return }
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
        label.font = .systemFont(ofSize: 25, weight: .heavy)
    }
    
}
