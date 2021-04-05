//
//  IEConstants.swift
//  ImageEditor
//
//  Created by Panchami Rao on 01/04/21.
//

import Foundation

enum IEFilterType {
    case color(subfilter: IEColorFilterSubtype)
    case style(subfilter: IEStyleFilterSubtype)
    case blur(subfilter: IEBlurFilterSubtype)
    case none

    var hasIntensity: Bool {
        var isIntensityPresent = false
        switch self {
        case .color(let subtype):
            switch subtype {
            case .sepeia:
                isIntensityPresent = true
            default:
                isIntensityPresent = false
            }
        case .style:
            isIntensityPresent = true
        default:
            isIntensityPresent = false
        }
        return isIntensityPresent
    }

    var hasRadius: Bool {
        var isRadiusPresent = false
        switch self {
        case .color(let subtype):
            switch subtype {
            default:
                isRadiusPresent = false
            }
        case .style:
            isRadiusPresent = true
        case .blur:
            isRadiusPresent = true
        default:
            isRadiusPresent = false
        }
        return isRadiusPresent
    }
}

enum IEColorFilterSubtype {
    case sepeia(intensity: Float)
    case transfer
}

enum IEStyleFilterSubtype {
    case bloom(intensity: Float, radius: Float)
    case gloom(intensity: Float, radius: Float)
}

enum IEBlurFilterSubtype {
    case disc(radius: Float)
    case rectangular(radius: Float)
}

protocol IEPreviewProtocol {
    func applyFilter(_ filterType: IEFilterType)
}
