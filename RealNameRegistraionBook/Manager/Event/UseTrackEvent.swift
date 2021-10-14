//
//  UseTrackEvent.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/10/14.
//

import Foundation

// MARK: 切換頁籤
extension LogManager {
    
    /**
    #### 切換頁籤 事件
    - 計算條件：點擊頁面切換算一次
    - 採集時機：點擊時
    */

    
    enum UseTrackEvent: EventProtocol, EventPparameterProtocol {
        /// - 採集時機：點擊時
        case scan(result: ScanResult)
        /// - 採集時機： 上傳成功
        case storageClick
        
        
        var parameters: [String : Any]? {
            
            switch self {
            case .scan(let result):
                return [result.name: result.rawValue]
                
            default:
                return nil
            }
        }
        
        var name: String {
            switch self {
            case .scan:
                return "qrScan"
            case .storageClick:
                return "storage_cell_click"
            }
        }
    }
    
    /// 展開輸入頁 parameters
    enum ScanResult: String, EventPparameterProtocol {
        /// 播放頁留言區：文字輸入框
        case success = "success"
        /// 播放頁留言區：相機
        case failed = "failed"
        
        var name: String {
            return "result"
        }
        
    }
  
    
    static func useTrack(event: UseTrackEvent) {
        LogManager.logEvent(eventName: event.name, parameters: event.parameters)
    }
    
}
