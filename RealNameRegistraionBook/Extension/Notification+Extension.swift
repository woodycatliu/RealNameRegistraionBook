//
//  Notification+Extension.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/25.
//

import Foundation

extension NotificationCenter {
    
    static func addObserver(_ observer: Any, selector: Selector ,forName name: NotificationSelector, object: Any?) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: name.name, object: object)
    }
    
    static func post(forName name: NotificationSelector, object: Any?, userInfo: [AnyHashable : Any]?) {
        NotificationCenter.default.post(name: name.name, object: object, userInfo: userInfo)
    }
    
}

protocol NotificationEventProtocol {
    var notificationName: Notification.Name { get }
}

enum NotificationSelector {
    case `default`
    var name: Notification.Name {
        return .symbol
    }
}

extension Notification.Name {
    static let symbol = Notification.Name.init("symbol")
}
