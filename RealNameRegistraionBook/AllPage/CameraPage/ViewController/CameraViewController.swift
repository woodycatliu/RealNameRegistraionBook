//
//  CamaraViewController.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/26.
//

import UIKit
import Combine
import MessageUI


// MARK: Routable
extension CameraViewController: Routable {
    struct CamaraViewRouterPath: RouterPathable {
        var vcType: Routable.Type = CameraViewController.self
        var params: RouterParameter?
    }
    
    static func initWithParams(params: RouterParameter?) -> UIViewController {
        let uni = UINavigationController(rootViewController: CameraViewController())
        return uni
    }
}


class CameraViewController: UIViewController {
    
    private lazy var cameraView: CameraView = {
        let view = CameraView()
        return view
    }()
    
    private lazy var qrcodeScaner: QRCodeScanner = {
        let detecter = QRCodeDetecter()
        let scaner = QRCodeScanner(barcordDetecter: detecter)
        scaner.videoPreviewLayer = cameraView.videoPreviewLayer
        cameraView.videoPreviewLayer.session = scaner.captureSession
        scaner.videoPreviewLayer = cameraView.videoPreviewLayer
        scaner.delegate = self
        cameraView.addGestureRecognizer(UIPinchGestureRecognizer(target: scaner, action: #selector(scaner.pinchToZoom(_:))))
        
        return scaner
    }()
    
    private let toast = QRCodeScanerToastView()
    
    private var autoSafe: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        qrcodeScaner.setQRCodeScanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        qrcodeScaner.startCamera()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        qrcodeScaner.stopCamera()
    }
    
    private func setupUI() {
        let effectView = UIView()
        effectView.backgroundColor = AppSetting.Color.mainBlue.withAlphaComponent(0.25)
        view.backgroundColor = AppSetting.Color.white
        view.addSubview(effectView)
        effectView.fillSuperview()
        view.addSubview(cameraView)
        cameraView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        view.addSubview(toast)
        toast.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 24, bottom: 0, right: 24))
        
        toast.bottomConstraint = toast.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 200)
        toast.bottomConstraint?.isActive = true
    }
    
    
}

// MARK: Logic
extension CameraViewController: Send1922Protocol {
    
    @objc
    private func safeAction(_ switchBtn: UISwitch) {
        autoSafe = switchBtn.isOn
    }
    
    private func handleError(_ error: QRCodeDetectError) {
        toast.show(isShowing: true)
        toast.errorMessage(error: error)
        
    }
    
    private func handle1922SMS(_ sms: SMSBocode) {
        guard let message = sms.message else { return }
        toast.show(isShowing: false)
        send1922(message: message)
        
        if AppSetting.shared.isAutoSafe {
            CoreDataService.shared.addPlace(message: message)
        }
        
    }
    
}

// MARK: MFMessageComposeViewControllerDelegate
extension CameraViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch result {
        case .cancelled:
            cameraView.videoPreviewLayer.removeBarcodeIndicator()
            
            controller.dismiss(animated: true, completion: {
                self.qrcodeScaner.startScan = true
            })
        case .sent:
            break
        case .failed:
            qrcodeScaner.startScan = true
        @unknown default:
            qrcodeScaner.startScan = true
        }
    }

}

// MARK: QRCodeScannerDelegate
extension CameraViewController: QRCodeScannerDelegate {
    func successToFilterContent(results: [Any]) {
        if let sms = results.first as? SMSBocode {
            handle1922SMS(sms)
        }
        else {
            qrcodeScaner.startScan = true
        }
    }
    func scanerFailedQRCode(error: Error) {
        guard let error = error as? QRCodeDetectError else { return }
        handleError(error)
    }
}
