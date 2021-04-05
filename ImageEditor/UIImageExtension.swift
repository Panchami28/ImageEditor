//
//  UIImageExtension.swift
//  ImageEditor
//
//  Created by Panchami Rao on 01/04/21.
//

import Foundation
import UIKit

// MARK: -
// MARK: Fixing the orientation
// MARK: -
extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage
    }
}
