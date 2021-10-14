//
//  Router.swift
//  iOS_MomDad
//
//  Created by Woody Liu on 2021/5/31.
//

import UIKit

public typealias RouterParameter = [String: Any]


protocol Routable where Self: UIViewController {
    
    /*
     初始化 ViewController 方法
     params: 提供 UIViewController init 參數的方法
     */
    
    static func initWithParams(params: RouterParameter?)-> UIViewController
}


protocol RouterPathable {
    
    // viewController 型別
    var vcType: Routable.Type { get }
    
    var params: RouterParameter? { get set }
    
    func initWithParams()-> UIViewController
}

extension RouterPathable {
    func initWithParams()-> UIViewController {
        return vcType.initWithParams(params: params)
    }
}


protocol RouterObject {
    
    var path: RouterPathable { get }
    
    var viewController: UIViewController { get }
    
}

extension RouterObject {
    var viewController: UIViewController {
        return path.initWithParams()
    }
}


protocol RouterProtocol: AnyObject {
    
    var window: UIWindow? { get set }
        
    var tabBarController: UITabBarController? { get set }
    
    var navigationController: UINavigationController? { get set }
    
    func selectedViewController(_ index: Int) -> Bool
        
    func getTopViewController(viewController vc: UIViewController?) -> UIViewController?
    
    func popViewController()
    
    
    @discardableResult
    func pushViewController(router: RouterPathable, animation: Bool) -> UIViewController
    /// 遵從 RouterObject enum 處理 Router 事件
    @discardableResult
    func pushViewController(router: RouterObject, animation: Bool) -> UIViewController
    /// 遵從 RouterObject enum 處理 Router 事件
    @discardableResult
    func presentViewController(router: RouterPathable, animation: Bool, completeion: (()->())?)-> UIViewController
    @discardableResult
    func presentViewController(router: RouterObject, animation: Bool, completeion: (()->())?)-> UIViewController
    
}

// MARK: topViewController
extension RouterProtocol {
    
    func getTopViewController()-> UIViewController? {
        return getTopViewController(viewController: navigationController)
    }
    
    func getTopViewController(viewController vc: UIViewController?)-> UIViewController? {
        
        if let navigationController = vc as? UINavigationController{
            if let visibleVC = navigationController.visibleViewController{
                return getTopViewController(viewController: visibleVC)
            }
        }
        if let tabController = vc as? UITabBarController{
            if let selected = tabController.selectedViewController{
                return getTopViewController(viewController: selected)
            }
        }
        if let presented = vc?.presentedViewController{
            return getTopViewController(viewController: presented)
        }
        if let alertController = vc as? UIAlertController{
            if let presentingViewController = alertController.presentingViewController{
                return presentingViewController
            }
        }
        return vc
    }
    
    func popViewController() {
        if let topViewController = getTopViewController(viewController: navigationController) {
            topViewController.navigationController?.popViewController(animated: true)
        }
    }
    
}

// MARL: tabController
extension RouterProtocol {
    
    @discardableResult
    func selectedViewController(_ index: Int)-> Bool {
        
        guard let tabBarController = tabBarController,
              let viewControllers = tabBarController.viewControllers,
              viewControllers.indices.contains(index) else { return false }
        
        let viewController = viewControllers[index]
        
        if let navigationController =  viewController as? UINavigationController {
            self.navigationController = navigationController
        }
                
        if index == tabBarController.selectedIndex {
            
            if let topVC = getTopViewController(),
               !topVC.isScrolledToTop {
                topVC.scrollToTop()
                return false
            }
        }
        
        return true
    }
    
}

// MARK: Push
extension RouterProtocol {
    
    @discardableResult
    func pushViewController(router: RouterPathable, animation: Bool)-> UIViewController {
        
        let vc = router.initWithParams()
                
        navigationController?.pushViewController(vc, animated: true)
        
        return vc
        
    }

    @discardableResult
    func pushViewController(router: RouterObject, animation: Bool)-> UIViewController {
        
        let vc = router.viewController
                
        navigationController?.pushViewController(vc, animated: animation)
        
        return vc
        
    }
    
    func pushViewController(viewController: UIViewController, animation: Bool) {
        navigationController?.pushViewController(viewController, animated: animation)
    }

}

// MARK: Present
extension RouterProtocol {
 
    @discardableResult
    func presentViewController(router: RouterPathable, animation: Bool, completeion: (()->())?)-> UIViewController {
       let vc = router.initWithParams()
        
        guard let navigationController = navigationController,
              let topvc = getTopViewController(viewController: navigationController)
        else { return vc}
        
        topvc.present(vc, animated: animation, completion: completeion)
        
        return vc
        
    }
    
    @discardableResult
    func presentViewController(router: RouterObject, animation: Bool, completeion: (()->())?)-> UIViewController {
        let vc = router.viewController

        guard let navigationController = navigationController,
              let topvc = getTopViewController(viewController: navigationController)
        else { return vc}
        
        
        topvc.present(vc, animated: animation, completion: completeion)

        return vc
    }
    
    @discardableResult
    func presentViewController(viewController: UIViewController, animation: Bool, completeion: (()->())?)-> UIViewController {
        
        guard let navigationController = navigationController,
              let topvc = getTopViewController(viewController: navigationController)
        else { return viewController }
        
        
        topvc.present(viewController, animated: animation, completion: completeion)

        return viewController
    }
    
    
}






/*
 ##### Use
 
 class ExampleViewController: UIViewController {
 
 var id: String?
 
 convenience init(id: String) {
 self.init()
 self.id = id
 }
 }
 extension ExampleViewController: Routable {
 static func initWithParams(params: RouterParameter?) -> UIViewController {
 guard let params = params, let id = params["id"] as? String else { return ExampleViewController() }
 return ExampleViewController(id: id)
 }
 
 }
 
 struct ExamplePath: RouterPathable {
 
 var vcType: Routable.Type {
 return ExampleViewController.self
 }
 
 var params: RouterParameter?
 
 func initWithParams()-> UIViewController {
 return vcType.initWithParams(params: params)
 }
 
 }
 
 
 enum ExampleType: RouterObject {
 
 case example(params: RouterParameter?)
 
 var path: RouterPathable {
 switch self {
 case .example(let params):
 return ExamplePath(params: params)
 }
 }
 
 var viewController: UIViewController {
 switch self {
 case .example:
 return path.initWithParams()
 }
 }
 
 }
 
 
 class Vc: UIViewController {
 func pushViewController(routePath: RouterObject) {
 navigationController?.pushViewController(routePath.viewController, animated: true)
 }
 }
 
 */
