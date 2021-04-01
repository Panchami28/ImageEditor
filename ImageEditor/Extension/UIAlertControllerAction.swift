//
//  UIAlertControllerAction.swift
//  ImageEditor
//
//  Created by Panchami Rao on 01/04/21.
//

import Foundation
import UIKit

extension UIAlertController {
    
   /**
    Convenience Initialiser for UIAlertController
    - parameters:
        - alertType: Type of the alert you are looking to present.
        - defaultAction: Action for which you presented the alert for.
        - cancelAction: Action on pressing cancellation button.

    */

    convenience init(alertType: AlertType,
                     alert1Action: (() -> Void)?,
                     alert2Action: (() -> Void)?,
                     alert3Action: (() -> Void)?) {
        let alert = AlertFactory.alert(forType: alertType)
        self.init(title: alert.title,
                  message: alert.message,
                  preferredStyle: .actionSheet)
        
        let userAlert1Action = UIAlertAction(title: alert.alert1ActionTitle,style: .default) { (action) in
            alert1Action?()
        }
        self.addAction(userAlert1Action)
        
        let userAlert2Action = UIAlertAction(title: alert.alert2ActionTitle,style: .default) { (action) in
            alert2Action?()
        }
        self.addAction(userAlert2Action)
        
        let userAlert3Action = UIAlertAction(title: alert.alert3ActionTitle,style: .default) { (action) in
            alert3Action?()
        }
        self.addAction(userAlert3Action)
    }
}
