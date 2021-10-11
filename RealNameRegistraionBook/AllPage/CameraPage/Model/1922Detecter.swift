//
//  1922Detecter.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/26.
//

import UIKit
import AVFoundation


class QRCodeDetecter: BarcodeDetecterProtocol {
    
    func checkBarcodeFrame(_ frames: [CGRect], inSampleBufferSize size: CGSize, validScanObjectFrame: CGRect?) -> Bool {
        return true
    }
    
    func detectBarcodes(_ barcodes: [MLBarcode]) -> Result<[Any], Error> {
        var errorSMS: [SMSBocode] = []
        
        for barcode in barcodes {
            guard let sms = barcode.sms,
                  let phone = sms.phoneNumber
            else { continue }
            
            if phone == "1922" {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                return .success([sms])
            }
            errorSMS.append(sms)
        }
        
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        return errorSMS.isEmpty ?
            .failure(QRCodeDetectError.isNotSMS) :
            .failure(QRCodeDetectError.isNot1922(errorSMS))
    }
    
}

enum QRCodeDetectError: Error {
     case isNotSMS
     case isNot1922(_ contents: [SMSBocode])
}
