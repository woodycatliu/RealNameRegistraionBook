//
//  AppSetting.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/29.
//

import Foundation
import Combine
import UIKit

class AppSetting {
    static let shared: AppSetting = AppSetting()
    private init(){}
    
    @Published
    var isAutoSafe: Bool = true
    
    func setNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = Color.mainBlue.withAlphaComponent(0.9)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().isTranslucent = true
    }
}

extension AppSetting {
    struct Color {
        static let textDark: UIColor = .init(hex: "082032")
        static let textSecondDark: UIColor = .init(hex: "2C394B")
        static let darkBlue: UIColor = .init(hex: "00A8CC")
        static let mainBlue: UIColor = .init(hex: "93B5C6")
        static let white: UIColor = .init(hex: "FEFBF3")
        static let background: UIColor = .init(hex: "F7F6F2")
    }
}

extension AppSetting {
    static let googleAdsID: String = "ca-app-pub-7271298692272170/8007000536"
    static let googleTestID: String = "ca-app-pub-3940256099942544/2934735716"
}
