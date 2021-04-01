//
//  UIApplicationExtension.swift
//  ImageEditor
//
//  Created by Panchami Rao on 01/04/21.
//

import Foundation
import UIKit

extension UIApplication {
    /**
     Convenience Initialiser for UIAlertController
     - parameters:
     - alertType: Type of the alert you are looking to present.
     - onViewController: Presenter for the alert.
     - animated: Default to true.
     - completion: Alert's completion block.
     - userAction: Action for which you presented the alert for.
     Generally the action for button on the right side of alert in Lefto for Right languages.
     - cancelAction: Action on pressing cancellation button.
     */
    
    func showAlert(ofType alertType: AlertType,
                   onViewController presenter: UIViewController,
                   animated: Bool = true,
                   alert1Action: (() -> Void)?,
                   alert2Action: (() -> Void)?,
                   alert3Action: (() -> Void)?) {
        
        let alertController = UIAlertController(alertType: alertType, alert1Action: alert1Action, alert2Action: alert2Action, alert3Action: alert3Action)
        
            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popoverPresentationController = alertController.popoverPresentationController {
                    popoverPresentationController.permittedArrowDirections = .up
                    popoverPresentationController.sourceView = presenter.view
                    popoverPresentationController.sourceRect = CGRect(x: presenter.view.frame.maxX-50, y: presenter.view.frame.minY+25, width: 30, height: 30)
                    alertController.modalPresentationStyle = .popover
                    presenter.present(alertController, animated: true, completion: nil)
                }
            } else {
                presenter.present(alertController, animated: true, completion: nil)
            }
    }
}
