//
//  TabBarViewController.swift
//  iOS_MomDad
//
//  Created by Woody Liu on 2021/5/31.
//

import UIKit
import Combine


class TabBarViewController: UITabBarController {
    
    let normalColor: UIColor = UIColor.init(hex: "A8E7E9")
    
    let highlightedColor: UIColor = .mainColor
    
    private var anycancellables = Set<AnyCancellable>()
    
    private lazy var safeButton: UISwitch = {
        let btn = UISwitch()
        btn.isOn = AppSetting.shared.isAutoSafe
        btn.addTarget(self, action: #selector(safeAction(_:)), for: .valueChanged)
        btn.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        btn.onTintColor = .mainColor
        return btn
    }()
    
    private lazy var safeLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 14, weight: .bold)
        lb.textColor = highlightedColor
        lb.textAlignment = .center
        lb.text = "自動儲存"
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        commonInit()
        observed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceTabarColor()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let lastItem = tabBar.subviews.last {
            tabBar.addSubview(safeButton)
            tabBar.addSubview(safeLabel)
            safeButton.centerXTo(lastItem.centerXAnchor)
            if UIApplication.isThereNotch {
                safeButton.centerYAnchor.constraint(equalTo: lastItem.centerYAnchor, constant: 0).isActive = true
                safeLabel.centerXTo(lastItem.centerXAnchor)
                safeLabel.anchor(top: safeButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
            }
            else {
                safeButton.centerYAnchor.constraint(equalTo: lastItem.centerYAnchor, constant: -10).isActive = true
                safeLabel.centerXTo(lastItem.centerXAnchor)
                safeLabel.anchor(top: safeButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
                safeLabel.font = .systemFont(ofSize: 13, weight: .bold)
            }
            
        }
        
    }
    
    private func commonInit() {
        let arr: [TabBarType] = [.main, .scan, .autoSafe]
        
        var vcs: [UIViewController] = []

        arr.forEach {
            let vc = $0.viewController
            let tabBarItem = UITabBarItem(title: $0.title?.localized(), image: $0.normalImg, selectedImage: $0.selectedImg)
            
            if UIApplication.isThereNotch {
                tabBarItem.imageInsets = .init(top: 15, left: 0, bottom: -10, right: 0)
                tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: .adjustFloat(min: -1, max: 3))
            }
            else {
                tabBarItem.imageInsets = .init(top: 10, left: 0, bottom: 0, right: 0)
            }
            
            
            tabBarItem.tag = $0.rawValue
            vc.tabBarItem = tabBarItem
            vcs.append(vc)
            
        }
        viewControllers = vcs
        
    }
    
    fileprivate func appearanceTabarColor() {
        if #available(iOS 15, *) {
            let appearance = UITabBarAppearance()
                        
            appearance.configureWithOpaqueBackground()
            
            appearance.compactInlineLayoutAppearance.selected.iconColor = highlightedColor
            appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: highlightedColor]
            
            appearance.compactInlineLayoutAppearance.normal.iconColor = normalColor
            appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normalColor]
            
            appearance.inlineLayoutAppearance.selected.iconColor = highlightedColor
            appearance.inlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: highlightedColor]
            
            appearance.inlineLayoutAppearance.normal.iconColor = normalColor
            appearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normalColor]
            
            appearance.stackedLayoutAppearance.selected.iconColor = highlightedColor
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: highlightedColor]
            
            appearance.stackedLayoutAppearance.normal.iconColor = normalColor
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normalColor]
            
            appearance.backgroundColor = AppSetting.Color.mainBlue.withAlphaComponent(0.9)
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        
            return
        }
        
        tabBar.unselectedItemTintColor = .init(hex: "C4E4E5")
        tabBar.tintColor = .mainColor
        
    }
    
    
}

extension TabBarViewController {
    private func observed() {
        AppSetting.shared.$isAutoSafe
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                guard let self = self else { return }
                self.safeLabel.textColor = $0 ? self.highlightedColor : self.normalColor
            })
            .store(in: &anycancellables)
    }
}

//MARK: objc
extension TabBarViewController {
    @objc
    private func safeAction(_ switchBtn: UISwitch) {
        let bool = switchBtn.isOn
        AppSetting.shared.isAutoSafe = switchBtn.isOn
        safeLabel.textColor = bool ? highlightedColor : normalColor
    }
    
}

extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let index = viewControllers?.firstIndex(of: viewController),
           let type = TabBarType.init(rawValue: index),
           type != .autoSafe {
            return Router.shared.selectedViewController(index)
        }
        return false
    }
    
}


extension UIApplication {
    static var isThereNotch: Bool {
        let bottomInset: CGFloat
        if #available(iOS 15.0, *) {
            bottomInset = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets.bottom ?? 0
        } else {
            bottomInset = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets.bottom ?? 0
        }
        return bottomInset != 0
    }
}
