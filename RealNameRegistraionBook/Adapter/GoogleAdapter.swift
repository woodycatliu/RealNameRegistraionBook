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
    
    enum BannerType: Int, CustomStringConvertible {
        case main
        case camera
        var description: String {
            switch self {
            case .main:
                return "main"
            case .camera:
                return "camera"
            }
        }
    }
    
    static let shared: GoogleAdsadapter = GoogleAdsadapter()
    
//    weak var delegate: ViewControllerAdsDelegae?
    
    private var delegates: WeakDictionary<ViewControllerAdsDelegae> = WeakDictionary<ViewControllerAdsDelegae>()
    
    var bannerViews: [Int: GADBannerView] = [:]
        
    func register(vc: ViewControllerAdsDelegae, type: BannerType) {
        if let _ = bannerViews[type.rawValue] {
            return
        }
        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        #if DEBUG
        bannerView.adUnitID = AppSetting.googleTestID
        #else
        bannerView.adUnitID = AppSetting.googleAdsID
        #endif
        bannerView.rootViewController = vc as? UIViewController
        bannerView.delegate = self
        bannerView.load(GADRequest())
        bannerView.tag = type.rawValue
        bannerViews[type.rawValue] = bannerView
        delegates.addDelegate(delegate: vc, identifier: type.description)
    }
    
}

// MARK: GADBannerViewDelegate
extension GoogleAdsadapter: GADBannerViewDelegate {
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        guard let type = BannerType.init(rawValue: bannerView.tag) else { return }
        Logger.log(message: "bannerViewDidReceiveAd")
//        delegate?.addBannerViewToView(bannerView: bannerView)
        delegates[type.description]?.addBannerViewToView(bannerView: bannerView)

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
