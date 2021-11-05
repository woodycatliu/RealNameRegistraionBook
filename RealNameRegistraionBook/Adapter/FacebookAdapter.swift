//
//  FacebookAdapter.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/10/31.
//

import Foundation
import FBAudienceNetwork
import UIKit

typealias AdView = FBAdView

protocol ViewControllerFBAdsDelegae: AnyObject {
    func addAdViewToView(adView: AdView)
}

class FacebookAdapter: NSObject {
    
    static let shared: FacebookAdapter = FacebookAdapter()
    
    static let placementId: String = "385505866609954_385515193275688"
    
    weak var delegate: ViewControllerFBAdsDelegae?
    
    var adView: FBAdView?
    
    func register(viewController vc: ViewControllerFBAdsDelegae) {
        let adView = FBAdView(placementID: FacebookAdapter.placementId, adSize: kFBAdSizeHeight50Banner, rootViewController: vc as? UIViewController)
        adView.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
        adView.withSize(.init(width: 320, height: 50))
        delegate = vc
        adView.delegate = self
        adView.loadAd()
        self.adView = adView
    }
    
    
}

extension FacebookAdapter: FBAdViewDelegate {
    
    func adView(_ adView: FBAdView, didFailWithError error: Error) {
        Logger.log(message: "Ad failed to load with error: \(error)")
        adView.removeFromSuperview()
    }

    func adViewDidLoad(_ adView: FBAdView) {
        Logger.log(message: "Ad was loaded and ready to be displayed")
        guard adView.isAdValid else { return }
        delegate?.addAdViewToView(adView: adView)
    }
    
    
}
