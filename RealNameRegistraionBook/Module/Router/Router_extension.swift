//
//  Router_extension.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/26.
//

import UIKit

extension Router {
    
    func launchedApplecation() {
        let vc = LaunchViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    /// 初始化畫面。
    /// 時機：Launch APP 動畫跑完後，正式進入主頁。
    /// Any 需要重設主頁使用
    func initMainApplication(type: TabBarType = .main) {
                
        isFirstLaunch = false
        
        tabBarController = TabBarViewController()
        
        window?.rootViewController = tabBarController
        
        _ = selectedViewController(type: type)
        
        window?.makeKeyAndVisible()
        
    }
}

extension Router {
    
    func addNewGroupAlertController(toastView: ToastAlertView) {
        let controller = UIAlertController(title: "新增檔案夾", message: nil, preferredStyle: .alert)
        
        controller.addTextField(configurationHandler: { textField in
            textField.textColor = AppSetting.Color.textDark
        })
        
        let confirmAction = UIAlertAction(title: "確定".localized(), style: .default, handler: { _ in
            guard let textField = controller.textFields?.first else { return }
            
            guard let text = textField.text,
                  !text.isBlank else {
                      toastView.show(message: "請輸入資料夾名稱".localized())
                      return }
            
            if let _ = CoreDataService.shared.checkGroupExists(name: text) {
                toastView.show(message: "已經有相同的分組囉".localized())
                return
            }
            CoreDataService.shared.addGroup(name: text)
            
        })
        
        confirmAction.setValue(AppSetting.Color.textSecondDark, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "取消".localized(), style: .default, handler: nil)
        cancelAction.setValue(AppSetting.Color.textSecondDark, forKey: "titleTextColor")
        
        controller.addAction(cancelAction)
        
        controller.addAction(confirmAction)
        
        
        Router.shared.showCustomAlertController(alertController: controller)
    }
    
}


extension Router {
    
    func editGroupAlertController(toastView: ToastAlertView) {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let changeAction = UIAlertAction(title: "變更資料夾名稱", style: .default, handler: { _ in
            self.showDeleteGroupSelectionViewController(style: .changeName)
        })
        
        let deleteAction = UIAlertAction(title: "刪除資料夾", style: .default, handler: { _ in
            self.showDeleteGroupSelectionViewController(style: .delete)
        })
        
        let addAction = UIAlertAction(title: "新增資料夾", style: .default, handler: { _ in
            self.addNewGroupAlertController(toastView: toastView)
        })
        
        let cancelAction = UIAlertAction(title: "取消".localized(), style: .cancel, handler: nil)
        
        cancelAction.setValue(AppSetting.Color.textSecondDark, forKey: "titleTextColor")
        changeAction.setValue(AppSetting.Color.textSecondDark, forKey: "titleTextColor")
        deleteAction.setValue(AppSetting.Color.textSecondDark, forKey: "titleTextColor")
        addAction.setValue(AppSetting.Color.textSecondDark, forKey: "titleTextColor")
        
        
        controller.addAction(addAction)
        controller.addAction(changeAction)
        controller.addAction(deleteAction)
        controller.addAction(cancelAction)
        
        showCustomAlertController(alertController: controller, completion: nil)
    }
    
    @discardableResult
    func showDeleteGroupSelectionViewController(style: GroupSelectionViewController.Style)-> GroupSelectionViewController {
        let path = GroupSelectionViewController.GroupSelectionRouterPath(style: style)
        return presentViewController(router: path, animation: true, completeion: nil) as! GroupSelectionViewController
    }
    
    @discardableResult
    func showGroupSelectionViewController(places: [RealNamePlace])-> GroupSelectionViewController {
        let path = GroupSelectionViewController.GroupSelectionRouterPath(places: places)
        return presentViewController(router: path, animation: true, completeion: nil) as! GroupSelectionViewController
    }
    
}

extension Router {
    
    func renameAlertController(indexPath: IndexPath) {
        let controller = UIAlertController(title: "重新命名", message: nil, preferredStyle: .alert)
        
        controller.addTextField(configurationHandler: { textField in
            textField.textColor = AppSetting.Color.textDark
        })
        
        let confirmAction = UIAlertAction(title: "確定".localized(), style: .default, handler: { _ in
            guard let textField = controller.textFields?.first else { return }
            
            guard let text = textField.text else { return }
            
            CoreDataService.shared.updateName(indexPath: indexPath, name: text, type: .place)
            
        })
        
        confirmAction.setValue(AppSetting.Color.textSecondDark, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "取消".localized(), style: .default, handler: nil)
        cancelAction.setValue(AppSetting.Color.textSecondDark, forKey: "titleTextColor")
        
        controller.addAction(cancelAction)
        
        controller.addAction(confirmAction)
        
        
        Router.shared.showCustomAlertController(alertController: controller)
    }
    
    
}
