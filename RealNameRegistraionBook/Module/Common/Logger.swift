//
//  Logger.swift
//  iOS_MomDad
//
//  Created by Woody Liu on 2021/5/31.
//

import Foundation

/*
方法一： print 出呼叫 file檔名
方法二： 傳入Caller
*/


class Logger {
    
    private init() {
    }
    
    static func log<T>(message: T, file: String = #file, method: String = #function, line: Int = #line) {
        #if DEBUG
        let time = DateUtility().getString(from: Date())
        let fileName = (file as NSString).lastPathComponent
        NSLog("######## [\(fileName): \(method)] \(message) - \(time) - at Line \(line) #######")
        #endif
    }
    
    static func log<T, U>(message: T, caller: U, method: String = #function, line: Int = #line) {
        #if DEBUG
        let time = DateUtility().getString(from: Date())
        NSLog("####### [\(caller).\(method)] \(message) - \(time) - at Line \(line) #######")
        #endif
    }

    static func log<T>(message: T, file: String = #file, _class: AnyObject, method: String = #function, line: Int = #line) {
        #if DEBUG
        let time = DateUtility().getString(from: Date())
        let fileName = (file as NSString).lastPathComponent
        let className = NSStringFromClass(type(of: _class))
        NSLog("#### [\(className).\(method)]- \(message) at fileName: \(fileName) in Time: \(time) - at Line \(line) ####")
        #endif

    }
    
    static func log<T, U>(message: T, apiCaller: U, line: Int = #line) {
        #if DEBUG
        NSLog("#### [\(apiCaller)] \(message) - at Line \(line) ####")
        #endif
    }


}
