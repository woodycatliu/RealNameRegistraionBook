//
//  FirebaseAnalyticsHelper.swift
//  iOS_MomDad
//
//  Created by Woody Liu on 2021/7/22.
//

import Foundation
import FirebaseAnalytics

class FirebaseAnalyticsHelper {
    
    init() {
        if FlagManager.isInDEVorDEBUG {
            // 關閉GA的Log
            Analytics.setAnalyticsCollectionEnabled(false)
        } else {
            Analytics.setAnalyticsCollectionEnabled(true)
        }
    }
    /// 紀錄有參數的fireBase的事件
    /// - Parameters:
    ///   - eventName: 事件名稱
    ///   - parameters: 事件參數
    static func logEvent(_ eventName: String, parameters: [String: Any]? = nil) {
        
        Analytics.logEvent(eventName, parameters: parameters)
    }
    
    static func setUerId(_ id: String) {
        
        Analytics.setUserID(id)
    }
    
    static func setUserProperty(name: String, value: String) {
        
        Analytics.setUserProperty(value, forName: name)
    }
}
