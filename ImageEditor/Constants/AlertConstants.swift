//
//  AlertConstants.swift
//  ImageEditor
//
//  Created by Panchami Rao on 01/04/21.
//

import Foundation
import UIKit

enum AlertType {
    case filterMenu
    case colorFilterMenu
    case styleFilterMenu
    case blurFilterMenu
}

struct FilterMenu: AlertProtocol {
    var title: String? { return "Filters" }
    var message: String? { return "" }
    var alert1ActionTitle: String? { return "Color Filters" }
    var alert2ActionTitle: String? { return "Style Filters" }
    var alert3ActionTitle: String? { return "Blur Filters" }
}

struct ColorFilterMenu: AlertProtocol {
    var title: String? { return "" }
    var message: String? { return "Choose required Color Filter"}
    var alert1ActionTitle: String? { return "Sepia Filter" }
    var alert2ActionTitle: String? { return "Photo Effect Filter" }
    var alert3ActionTitle: String? { return "" }
}

struct StyleFilterMenu: AlertProtocol {
    var title: String? { return "" }
    var message: String? { return "Choose required Style Filter"}
    var alert1ActionTitle: String? { return "Bloom Filter" }
    var alert2ActionTitle: String? { return "Gloom Filter" }
    var alert3ActionTitle: String? { return "" }
}

struct BlurFilterMenu: AlertProtocol {
    var title: String? { return "" }
    var message: String? { return "Choose required Blur Filter"}
    var alert1ActionTitle: String? { return "Rectangular Blur Filter" }
    var alert2ActionTitle: String? { return "Disc Blur Filter" }
    var alert3ActionTitle: String? { return "" }
}

