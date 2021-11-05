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
import FirebaseAnalytics
import Firebase
import FBAudienceNetwork
import AdSupport

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private(set) var fireBaseInstanceId: String = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        firebaseInstanceID()
        
        FBAudienceNetworkAds.initialize(with: nil, completionHandler: nil)

        FBAdSettings.setAdvertiserTrackingEnabled(true)

        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.requestAppTrackingTransparency()
        }
        
        Logger.log(message: "IDFA: \( getIDFA())")
        
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

    func firebaseInstanceID() {
        Installations.installations().installationID {[weak self] id, error in
            if let error = error {
                Logger.log(message: error, apiCaller: self)
            }
            else if let id = id {
                self?.fireBaseInstanceId = id
            }
        }
    }
    
    
}

extension AppDelegate {
    func getIDFA() -> String? {
        // Check whether advertising tracking is enabled
        if #available(iOS 14, *) {
            if ATTrackingManager.trackingAuthorizationStatus != ATTrackingManager.AuthorizationStatus.authorized  {
                return nil
            }
        } else {
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled == false {
                return nil
            }
        }

        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
}
