//
//  UIAlertController+Convenience.swift
//  ImageEditor
//
//  Created by Darshan D T on 01/04/21.
//

import Foundation
import UIKit

extension UIAlertController {
    func addActions(_ actions: [UIAlertAction]) {
        actions.forEach{ self.addAction($0)}
    }
}

extension UIAlertController {
    class func filterOptionsForImageEditing<T: ImageFilterViewController>(sourceViewController: T, sourceRect: CGRect? = nil) -> UIAlertController {
        let filterMenu = UIAlertController(title: "Filters", message: "Choose a Filter Category to apply on the image", preferredStyle: .actionSheet)
        let colorFilterAction = UIAlertAction(title: "Color Filters", style: .default) { (action) in
            let colorFilterMenu = UIAlertController(title: "Color", message: "Choose required Color Filter", preferredStyle: .actionSheet)
            let actions = Self.actionsForColorFilter(forSourceController: sourceViewController)
            colorFilterMenu.addActions(actions)
            sourceViewController.present(colorFilterMenu, animated: true, completion: nil)
        }

        let styleFilterAction = UIAlertAction(title: "Style Filters", style: .default) { (action) in
            let styleFilterMenu = UIAlertController(title: "Style", message: "Choose required Style Filter", preferredStyle: .actionSheet)
            let actions = Self.actionsForStyleFilter(forSourceController: sourceViewController)
            styleFilterMenu.addActions(actions)
            sourceViewController.present(styleFilterMenu, animated: true, completion: nil)
        }

        let blurFilterAction = UIAlertAction(title: "Blur Filters", style: .default) { (action) in
            let blurFilterMenu = UIAlertController(title: "Style", message: "Choose required Blur Filter", preferredStyle: .actionSheet)
            let actions = Self.actionsForStyleFilter(forSourceController: sourceViewController)
            blurFilterMenu.addActions(actions)
            sourceViewController.present(blurFilterMenu, animated: true, completion: nil)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
     
        filterMenu.addActions([colorFilterAction, styleFilterAction, blurFilterAction, cancelAction])
      return filterMenu
    }

    fileprivate class func actions<T: ImageFilterViewController>(forFilter filterType: IEFilterType, sourceController: T) -> [UIAlertAction] {
        var alertActions = [UIAlertAction]()
        switch filterType {
        case .color:
            alertActions = actionsForColorFilter(forSourceController: sourceController)
        case .style:
            alertActions = actionsForStyleFilter(forSourceController: sourceController)
        case .blur:
            alertActions = actionsForStyleFilter(forSourceController: sourceController)
        case .none:
            break
        }
        return alertActions
    }

    fileprivate class func actionsForColorFilter<T: ImageFilterViewController>(forSourceController sourceController: T) -> [UIAlertAction] {
        let sepiaFilterAction = UIAlertAction(title: "Sepia Filter", style: .default) { (action) in
            sourceController.applyFilter(.color(subfilter: .sepeia(intensity: 0)))
            }

        let transferFilterAction = UIAlertAction(title: "Photo Effect Transfer Filter", style: .default) { (action) in
            sourceController.applyFilter(.color(subfilter: .transfer))
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        return [sepiaFilterAction, transferFilterAction, cancelAction]
    }

    fileprivate class func actionsForStyleFilter<T: ImageFilterViewController>(forSourceController sourceController: T) -> [UIAlertAction] {
    
        let bloomFilterAction = UIAlertAction(title: "Bloom Filter", style: .default) { (action) in
            sourceController.applyFilter(.style(subfilter: .bloom(intensity: 0, radius: 0)))
        }

        let gloomFilterAction = UIAlertAction(title: "Gloom Filter", style: .default) { (action) in
            sourceController.applyFilter(.style(subfilter: .gloom(intensity: 0, radius: 0)))
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        return [bloomFilterAction, gloomFilterAction, cancelAction]
    }

    fileprivate class func actionsForBlurFilter<T: ImageFilterViewController>(forSourceController sourceController: T) -> [UIAlertAction] {
    
        let bloomFilterAction = UIAlertAction(title: "Disc Blur", style: .default) { (action) in
            sourceController.applyFilter(.blur(subfilter: .disc(radius: 5.0)))
        }

        let gloomFilterAction = UIAlertAction(title: "Rectangular Blur", style: .default) { (action) in
            sourceController.applyFilter(.blur(subfilter: .rectangular(radius: 5.0)))
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        return [bloomFilterAction, gloomFilterAction, cancelAction]
    }
}
