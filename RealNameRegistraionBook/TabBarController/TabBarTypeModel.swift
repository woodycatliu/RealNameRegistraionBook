//
//  TabBarTypeModel.swift
//  iOS_MomDad
//
//  Created by Woody Liu on 2021/5/31.
//

import UIKit

enum TabBarType: Int, CustomStringConvertible, RouterObject {
    
    case main, scan, autoSafe
    
    var description: String {
        switch self {
        case .main:
            return "首頁"
        case .scan:
            return "QRCode"
        case .autoSafe:
            return "自動存取"
        }
    }
    
    var path: RouterPathable {
        switch self {
        case .main:
            return SMSStorageViewController.SMSStorageRouterPath()
//            return ExampleRouterPath(color: .yellow)
        case .scan:
            return CameraViewController.CamaraViewRouterPath()
        case .autoSafe:
            return ExampleRouterPath(color: .yellow)
        }
    }
    
    var normalImg: UIImage? {
        switch self {
        case .main:
            return UIImage(systemName: "rectangle.grid.2x2.fill")?.imgWithNewSize(size: CGSize.init(width: 48, height: 48))
        case .scan:
            return  UIImage(systemName: "qrcode")?.imgWithNewSize(size: CGSize.init(width: 50, height: 50))
        case .autoSafe:
            return nil
        }
    }
    
    var selectedImg: UIImage? {
        switch self {
        case .main:
            return UIImage(systemName: "rectangle.grid.2x2.fill")?.imgWithNewSize(size: CGSize.init(width: 48, height: 48))
        case .scan:
            return  UIImage(systemName: "qrcode")?.imgWithNewSize(size: CGSize.init(width: 50, height: 50))
        case .autoSafe:
            return nil
        }
    }
    
    var title: String? {
        switch self {
        case .main:
            return nil
        case .scan:
            return nil
        case .autoSafe:
            return nil
        }
    }
    
}


/*
 以下是開發用，用來顯示預覽。。。
 */


class BaseNavigationController: UINavigationController, Routable {
    
    static func initWithParams(params: RouterParameter?) -> UIViewController {
        let vc = BaseViewController()
        vc.routerPath = params?["router"] as? RouterPathable
        
        let navi = UINavigationController(rootViewController: vc)
        return navi
    }
    
    
}

    
class BaseViewController: UIViewController, Routable {
    
    var routerPath: RouterPathable?
    
    private lazy var label: UILabel = {
        let lb = UILabel()
        lb.text = "開發中".localized()
        lb.textColor = .darkGray
        lb.textAlignment = .center
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        label.withHeight(30)
        label.centerInSuperview()
        
        let btn = UIButton(type: .infoLight)
        view.addSubview(btn)
        btn.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, size: .init(width: 80, height: 50))
        btn.centerXTo(view.centerXAnchor)
        btn.addTarget(self, action: #selector(puchVC), for: .touchUpInside)
        
    }
    
    @objc func puchVC() {
        guard let routerPath = routerPath else { return }
        _ = Router.shared.pushViewController(router: routerPath, animation: true)
    }
    
    static func initWithParams(params: RouterParameter?) -> UIViewController {
        let vc = BaseViewController()
        vc.routerPath = params?["router"] as? RouterPathable
        return vc
    }
}


struct ExampleRouterPath: RouterPathable {
    
    let color: UIColor
    
    var vcType: Routable.Type {
        return BaseNavigationController.self
    }
    
    var params: RouterParameter?
    
    init(color: UIColor, routerPath: RouterPathable? = nil) {
        self.color = color
        if let routerPath = routerPath {
            self.params = ["router": routerPath]
        }
    }
    
    func initWithParams() -> UIViewController {
        let vc = vcType.initWithParams(params: params)
        (vc as? UINavigationController)?.view.backgroundColor = color
        return vc
    }
    
}
