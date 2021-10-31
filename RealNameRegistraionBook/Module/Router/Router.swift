//
//  Router.swift
//  iOS_MomDad
//
//  Created by Woody Liu on 2021/5/31.
//

import UIKit
import Combine

class Router: RouterProtocol {
    
    private static var router: Router?
        
    static var shared: Router {
        if let router = router {
            return router
        }
        
        let r = Router()
        router = r
        return r
    }
    
    @Storage(key: .isFirstLaunch, defaultValue: true)
    var isFirstLaunch: Bool
    
    @Published
    var isLaunchedApp: Bool = false
    
    private init(){}
    
    weak var window: UIWindow?
    
    var tabBarController: UITabBarController?
    
    var navigationController: UINavigationController?
}


// MARK: tabBar 跳頁控制
extension Router {
    
    @discardableResult
    func selectedViewController(type: TabBarType)-> Bool {
        guard let tabBarController = tabBarController,
              let viewControllers = tabBarController.viewControllers,
              viewControllers.indices.contains(type.rawValue) else { return false }
        let viewController = viewControllers[type.rawValue]
        
        self.navigationController = viewController as? UINavigationController
        
        tabBarController.selectedIndex = type.rawValue
        return true
    }
    
    @discardableResult
    func selectedVCAndPushViewController(type: TabBarType, router: RouterPathable, animation: Bool)-> UIViewController? {
        if selectedViewController(type.rawValue) {
            return pushViewController(router: router, animation: animation)
        }
        return nil
    }
    
    @discardableResult
    func selectedVCAndPushViewController(type: TabBarType, router: RouterObject, animation: Bool)-> UIViewController? {
        if selectedViewController(type.rawValue) {
            return pushViewController(router: router, animation: animation)
        }
        return nil
    }
    
    @discardableResult
    func selectedVCAndPresentViewController(type: TabBarType, router: RouterObject, animation: Bool, completeion: (()->())?)-> UIViewController? {
        if selectedViewController(type.rawValue) {
            return presentViewController(router: router, animation: animation, completeion: completeion)
        }
        return nil
    }
    
    @discardableResult
    func popToRootViewControllers(type: TabBarType)-> Bool {
        guard let tabBarController = tabBarController,
              let viewControllers = tabBarController.viewControllers,
              viewControllers.indices.contains(type.rawValue),
              let nvc = viewControllers[type.rawValue] as? UINavigationController else { return false }
        nvc.popToRootViewController(animated: true)
        return true
    }
    
}

// MARK: UIAlertController
extension Router {
    
    
    /// 顯示 Alert樣式的 UIAlertController
    /// - Parameters:
    ///   - tintColor: default / cancel 樣式顏色 ＝預設為 mainGreen
    ///   - cancelType: 取消 alert 的名稱，預設為：確定
    ///   - title: alertController Title
    ///   - message: alertController message
    ///   - actions: 額外的 AlertAction
    func showAlertController(isShowGlobalPlayer isShowing: Bool = false, tintColor: UIColor = .mainColor, cancelTitle: String = "確定", title: String?, message: String?, actions: [UIAlertAction] = [], completion: (()-> Void)? = nil) {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.view.tintColor = tintColor
        let action = UIAlertAction(title: cancelTitle, style: .cancel, handler: {
            _ in
        })
        
        actions.forEach {
            controller.addAction($0)
        }
        controller.addAction(action)
        
        guard let navigationController = navigationController,
              let topvc = getTopViewController(viewController: navigationController)
        else {
            Logger.log(message: "失去最頂端 VC 控制")
            return }
                
        topvc.present(controller, animated: true, completion: completion)
    }
    
    
    /// 顯示 actionSheet 樣式的 UIAlertController
    /// - Parameters:
    ///   - cancelType: 取消 alert 的名稱，預設為：取消
    ///   - tintColor: default / cancel 樣式顏色 ＝預設為 Black
    ///   - title: alertController Title
    ///   - message: alertController message
    ///   - actions: 額外的 AlertAction
    func showSheetController(tintColor: UIColor = .mainColor, cancelTitle: String = "取消", title: String?, message: String?, actions: [UIAlertAction] = [], completion: (()-> Void)? = nil) {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        controller.view.tintColor = tintColor
        
        let action = UIAlertAction(title: cancelTitle, style: .cancel, handler: {
            _ in
        })
        
        actions.forEach {
            $0.setValue(tintColor, forKey: "titleTextColor")
            controller.addAction($0)
        }
        controller.addAction(action)
        
        guard let navigationController = navigationController,
              let topvc = getTopViewController(viewController: navigationController)
        else {
            Logger.log(message: "失去最頂端 VC 控制")
            return }
                
        topvc.present(controller, animated: true, completion: completion)
    }
    
    
    /// 需要特別更改的 alert Controller
    /// - Parameter controller: UIAlertController
    func showCustomAlertController(alertController controller: UIAlertController, completion: (()-> Void)? = nil) {
        guard let navigationController = navigationController,
              let topvc = getTopViewController(viewController: navigationController)
        else {
            Logger.log(message: "失去最頂端 VC 控制")
            return }
        
        topvc.present(controller, animated: true, completion: completion)
    }
    
}


