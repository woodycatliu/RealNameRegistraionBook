//
//  UIViewController+Extension.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/27.
//

import UIKit
import MessageUI

protocol Send1922Protocol {}

extension Send1922Protocol where Self: MFMessageComposeViewControllerDelegate {
    func send1922(message: String) {
        guard MFMessageComposeViewController.canSendText() else { return }
        let controller = MFMessageComposeViewController()
        controller.overrideUserInterfaceStyle = .dark
        controller.body = message
        controller.recipients = ["1922"]
        controller.messageComposeDelegate = self
        Router.shared.presentViewController(viewController: controller, animation: true, completeion: nil)
    }
    
}
