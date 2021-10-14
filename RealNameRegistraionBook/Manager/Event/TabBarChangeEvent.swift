//
//  TabBarChangeEvent.swift
//  iOS_MomDad
//
//  Created by Woody Liu on 2021/7/22.
//

import Foundation

// MARK: 切換頁籤
extension LogManager {
    
    /**
    #### 切換頁籤 事件
    - 計算條件：點擊頁面切換算一次
    - 採集時機：點擊時
    */
    enum TabBarChangeEvent: String, EventProtocol {
        /// 進入首頁
        case main = "tab_home"
        /// 進入討論區
        case qrScaner = "tab_qrScaner"
        /// 進入搜尋
        case autoSafe = "tab_autoSave"
       
        
        var parameters: [String : Any]? {
            return nil
        }
        
        static func initByTabBarType(_ type: TabBarType)-> TabBarChangeEvent {
            switch type {
            case .main:
                return .main
            case .scan:
                return .qrScaner
            case .autoSafe:
                return .autoSafe
            }
        }
    }
    
    
    /// 切換頁籤
    /// - Parameter tabBarType: TabBarType ，隱性呼 tabBarChange(event)
    static func tabBarChange(tabBarType: TabBarType) {
        let event = TabBarChangeEvent.initByTabBarType(tabBarType)
        LogManager.tabBarChange(event: event)
    }
    
    
    /// 切換頁籤
    /// - Parameter event: TabBarChangeType 事件
    static func tabBarChange(event: TabBarChangeEvent) {
        LogManager.logEvent(eventName: event.rawValue)
    }
    
}
