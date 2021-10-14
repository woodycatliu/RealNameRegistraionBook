///
//  LogManager.swift
//  iOS_MomDad
//
//  Created by Woody Liu on 2021/7/22.
//

import Foundation
import FirebaseAnalytics

protocol EventProtocol {
    var parameters: [String: Any]? { get }
}

protocol EventPparameterProtocol {
    var name: String { get }
}

class LogManager {
    
    public static let shared = LogManager()
    
    static func logEvent(eventName: String) {
        
        FirebaseAnalyticsHelper.logEvent(eventName, parameters: nil)
        
        Logger.log(message: "🔶\(eventName) logged")
    }
    
    static func logEvent(eventName: String, parameters: [String: Any]?) {
        FirebaseAnalyticsHelper.logEvent(eventName, parameters: parameters)
        Logger.log(message: "🔶\(eventName) logged: \(parameters)")
    }
    
}



