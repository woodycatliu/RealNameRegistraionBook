//
//  1922Detecter.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/26.
//

import UIKit
import AVFoundation


class QRCodeDetecter: BarcodeDetecterProtocol {
    var inSampleBufferSize: CGSize?
    
    func checkBarcodeFrame(_ frames: [CGRect], inSampleBufferSize size: CGSize, validScanObjectFrame: CGRect?) -> Bool {
        inSampleBufferSize = size
        return true
    }
    
    func detectBarcodes(_ barcodes: [MLBarcode], previewLayer: AVCaptureVideoPreviewLayer) -> Result<[Any], Error> {
        var errorSMS: [SMSBocode] = []
        var successSMS: [SMSBocode] = []
        
        previewLayer.removeBarcodeIndicator()
        
        for barcode in barcodes {
            guard let sms = barcode.sms,
                  let phone = sms.phoneNumber
            else { continue }
            
            if phone == "1922" {
                drawBarcodeIndicator(barcode: barcode, previewLayer: previewLayer, color: .init(hex: "3EDBF0"))
                successSMS.append(sms)
                //                return .success([sms])
            }
            else {
                drawBarcodeIndicator(barcode: barcode, previewLayer: previewLayer, color: .init(hex: "FF4646"))
                errorSMS.append(sms)
            }
        }
        
        if !successSMS.isEmpty {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            LogManager.useTrack(event: .scan(result: .success))
            return .success(successSMS)
        }
        
        LogManager.useTrack(event: .scan(result: .failed))
        return errorSMS.isEmpty ?
            .failure(QRCodeDetectError.isNotSMS) :
            .failure(QRCodeDetectError.isNot1922(errorSMS))
    }
    
    func drawBarcodeIndicator(barcode: MLBarcode, previewLayer: AVCaptureVideoPreviewLayer, color: UIColor) {
        guard let inSampleBufferSize = inSampleBufferSize else { return }
        let frame = convertedRectOfBarcodeFrame(frame: barcode.frame, inSampleBufferSize: inSampleBufferSize, previewLayer: previewLayer)
        
        let bezierPath = UIBezierPath()
        let width = frame.width
        let height = frame.height
        let scare: CGFloat = 5
        bezierPath.move(to: .init(x: frame.minX + width / scare, y: frame.minY))
        bezierPath.addLine(to: .init(x: frame.origin.x, y: frame.origin.y))
        bezierPath.addLine(to: .init(x: frame.minX, y: frame.minY + height / scare))
        
        
        bezierPath.move(to: .init(x: frame.maxX - width / scare, y: frame.minY))
        bezierPath.addLine(to: .init(x: frame.maxX, y: frame.minY))
        bezierPath.addLine(to: .init(x: frame.maxX, y: frame.minY + height / scare))

        bezierPath.move(to: .init(x: frame.minX, y: frame.maxY - height / scare))
        bezierPath.addLine(to: .init(x: frame.minX, y: frame.maxY))
        bezierPath.addLine(to: .init(x: frame.minX + width / scare, y: frame.maxY))

        bezierPath.move(to: .init(x: frame.maxX - width / scare, y: frame.maxY))
        bezierPath.addLine(to: .init(x: frame.maxX, y: frame.maxY))
        bezierPath.addLine(to: .init(x: frame.maxX, y: frame.maxY - height / scare))
        bezierPath.lineJoinStyle = .round
        bezierPath.lineCapStyle = .butt
        bezierPath.stroke()
        
        let layer = CAShapeLayer()
        layer.name = AVCaptureVideoPreviewLayer.QRCodeIndicatorKey
        layer.frame = previewLayer.bounds
        layer.path = bezierPath.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color.cgColor
        layer.lineWidth = 3.5
        layer.lineCap = .round
        layer.lineJoin = .round
        layer.cornerRadius = 10
        layer.lineDashPhase = 0
        previewLayer.addSublayer(layer)
        
    }
    
    
}

enum QRCodeDetectError: Error {
     case isNotSMS
     case isNot1922(_ contents: [SMSBocode])
}
