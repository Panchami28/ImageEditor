//
//  AlertProtocols.swift
//  ImageEditor
//
//  Created by Panchami Rao on 01/04/21.
//

import Foundation
import UIKit

protocol AlertProtocol {
    var title: String? { get }
    var message: String? { get }
    var alert1ActionTitle: String? { get }
    var alert2ActionTitle: String? { get }
    var alert3ActionTitle: String? { get }
}
