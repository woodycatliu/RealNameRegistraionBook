//
//  NotificationManager.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/10/29.
//

import Foundation
import Combine


class NotificationManager {
    
    enum TargetType: String {
        case main = "game://main"
        case scan = "game://qrcode"
        
        var tabBarType: TabBarType {
            switch self {
            case .scan:
                return .scan
            case .main :
                return .main
            }
        }
    }
    
    private var cancellable: AnyCancellable?
     
    static let shared: NotificationManager = NotificationManager()
    
    private init() {
        observed()
    }
    
    private var cacheTarget: TargetType?
    
    private func observed() {
        cancellable = Router.shared.$isLaunchedApp
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                if $0 {
                    self?.transitionTarget()
                }
            })
    }
    
    private func transitionTarget() {
        guard let type = cacheTarget else { return }
        Router.shared.selectedViewController(type: type.tabBarType)
        cacheTarget = nil
    }
    
    func transitionTarget(target rawValue: String) {
        guard let targetType = TargetType.init(rawValue: rawValue) else { return }
        if Router.shared.isLaunchedApp {
            cacheTarget = nil
            Router.shared.selectedViewController(type: targetType.tabBarType)
        }
        else {
            cacheTarget = targetType
        }
    }
    
    
    
    
}
