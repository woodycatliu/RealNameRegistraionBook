//
//  AppDelegate.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/25.
//

import UIKit
import CoreData
import GoogleMobileAds
import AppTrackingTransparency



@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.requestAppTrackingTransparency()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}


extension AppDelegate {
    
    /// 要求允許
    private func requestAppTrackingTransparency() {

          if #available(iOS 14, *) {

              ATTrackingManager.requestTrackingAuthorization { (status) in
                  switch status {
                  case .authorized:
                    Logger.log(message: "✅使用者同意追蹤IDFA")

                  case .denied:
                    Logger.log(message: "🚫使用者拒絕追蹤IDFA")

                  case .notDetermined:
                      Logger.log(message: "🚫notDetermined")
                  case .restricted:
                      Logger.log(message: "🚫restricted")
                  @unknown default:
                      break
                  }
              }
          }
      }

}
