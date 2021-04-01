//
//  UIViewController+Convenience.swift
//  ImageEditor
//
//  Created by Darshan D T on 01/04/21.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlertController(_ alertController: UIAlertController) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverPresentationController = alertController.popoverPresentationController {
                popoverPresentationController.permittedArrowDirections = .up
                popoverPresentationController.sourceView = self.view
                popoverPresentationController.sourceRect = CGRect(x: self.view.frame.maxX-50, y: self.view.frame.minY+25, width: 30, height: 30)
                alertController.modalPresentationStyle = .popover
                present(alertController, animated: true, completion: nil)
            }
        } else {
            present(alertController, animated: true, completion: nil)
        }
    }
}
