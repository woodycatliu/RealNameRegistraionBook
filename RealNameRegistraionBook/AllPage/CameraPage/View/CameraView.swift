//
//  CamaraView.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/26.
//

import UIKit
import AVFoundation

class CameraView: UIView {
    
    let videoPreviewLayer: AVCaptureVideoPreviewLayer = {
        let vpl = AVCaptureVideoPreviewLayer()
        vpl.videoGravity = .resizeAspectFill
        return vpl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        videoPreviewLayer.frame = frame
        layer.addSublayer(videoPreviewLayer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        videoPreviewLayer.frame = frame
        layer.addSublayer(videoPreviewLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        videoPreviewLayer.frame = bounds
    }

    
}
