//
//  FlagManager.swift
//  iOS_MomDad
//
//  Created by Woody Liu on 2021/7/22.
//

import UIKit

struct FlagManager {
    
    /// 是否在DEV的環境下
    static var isInDEV: Bool = {
        // 得到目前環境下的參數
        let environment = ProcessInfo.processInfo.environment
        if environment["DEV"] != nil {
            return true
        } else {
            return false
        }
    }()
    
    /// 是否在DEBUG的環境下
    static var isInDEBUG: Bool = {
        // 得到目前環境下的參數
        let environment = ProcessInfo.processInfo.environment
        if environment["DEBUG"] != nil {
            return true
        } else {
            return false
        }
    }()
    
    /// 是否在DEBUG 或 DEV的環境下
    static var isInDEVorDEBUG: Bool = {
        // 得到目前環境下的參數
        let environment = ProcessInfo.processInfo.environment
        
        if environment["DEV"] != nil {
            return true
        }
        
        if environment["DEBUG"] != nil {
            return true
        }
        
        return false
    }()
    
    /// 在正式環境下
    static var isInRelease: Bool = {
        // 得到目前環境下的參數
        let environment = ProcessInfo.processInfo.environment
        
        if environment["DEV"] == nil && environment["DEBUG"] == nil {
            return true
        }
        
        return false
    }()
    
    
}
