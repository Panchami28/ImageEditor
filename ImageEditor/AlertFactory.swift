//
//  AlertFactory.swift
//  ImageEditor
//
//  Created by Panchami Rao on 01/04/21.
//

import Foundation
import UIKit

class AlertFactory {
    static func alert(forType alertType: AlertType) -> AlertProtocol {
        var alert: AlertProtocol
        switch alertType {
        case .filterMenu: alert = FilterMenu()
        case .colorFilterMenu: alert = ColorFilterMenu()
        case .styleFilterMenu: alert = StyleFilterMenu()
        case .blurFilterMenu: alert = BlurFilterMenu()
        }
        return alert
    }
}
