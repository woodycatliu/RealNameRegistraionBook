//
//  GoogleAdapter.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/10/1.
//

import Foundation
import GoogleMobileAds

protocol ViewControllerAdsDelegae: AnyObject {
    func addBannerViewToView(bannerView: BannerView)
}

typealias BannerView = GADBannerView

class GoogleAdsadapter: NSObject {
    
    static let shared: GoogleAdsadapter = GoogleAdsadapter()
    
    weak var delegate: ViewControllerAdsDelegae?
    
    var bannerView: GADBannerView?
        
    func register(vc: ViewControllerAdsDelegae) {
        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        #if DEBUG
        bannerView.adUnitID = AppSetting.googleTestID
        #else
        bannerView.adUnitID = AppSetting.googleAdsID
        #endif
        bannerView.rootViewController = vc as? UIViewController
        bannerView.delegate = self
        bannerView.load(GADRequest())
        self.bannerView = bannerView
        delegate = vc
    }
    
}

// MARK: GADBannerViewDelegate
extension GoogleAdsadapter: GADBannerViewDelegate {
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        Logger.log(message: "bannerViewDidReceiveAd")
        delegate?.addBannerViewToView(bannerView: bannerView)
        bannerView.alpha = 0
          UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
          })
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        Logger.log(message: "bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        bannerView.removeFromSuperview()
    }

}
