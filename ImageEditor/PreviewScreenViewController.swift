//
//  PreviewScreenViewController.swift
//  ImageEditor
//
//  Created by Panchami Rao on 23/03/21.
//

import UIKit

class PreviewScreenViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet var imageViewDoubleTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var imageViewTripleTapGestureRecognizer: UITapGestureRecognizer!
    
    var previewImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Preview"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filters", style: .plain, target: self, action: #selector(addTapped))
        previewImageView.image = previewImage
        imageScrollView.delegate = self
        imageViewDoubleTapGestureRecognizer.delegate = self
        let context = CIContext()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return previewImageView
    }

    // MARK: -
    // MARK: IB Actions
    // MARK: -
    @IBAction func doubleTapImage(_ sender: UITapGestureRecognizer) {
        if imageScrollView.zoomScale == imageScrollView.minimumZoomScale {
            imageScrollView.zoom(to: zoomRectangle(scale: imageScrollView.maximumZoomScale/2, center: sender.location(in: sender.view)), animated: true)
            } else {
                imageScrollView.setZoomScale(imageScrollView.minimumZoomScale, animated: true)
            }
        //print("Scale values: \(imageScrollView.maximumZoomScale) \(imageScrollView.minimumZoomScale)")
    }
    
    
    @IBAction func tripleTapImage(_ sender: UITapGestureRecognizer) {
        if imageScrollView.zoomScale == imageScrollView.minimumZoomScale {
            imageScrollView.zoom(to: zoomRectangle(scale: imageScrollView.maximumZoomScale, center: sender.location(in: sender.view)), animated: true)
            } else {
                imageScrollView.setZoomScale(imageScrollView.minimumZoomScale, animated: true)
            }
    }
    

    // MARK: -
    // MARK: Private Methods
    // MARK: -
    private func zoomRectangle(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = previewImageView.frame.size.height / scale
        zoomRect.size.width  = previewImageView.frame.size.width  / scale
        zoomRect.origin.x = center.x - ((zoomRect.size.width)/2)
        zoomRect.origin.y = center.y - ((zoomRect.size.height)/2)

//        print("Center: \(center)")
//        print("Origin values x: \(zoomRect.origin.x) y: \(zoomRect.origin.y)")
//        print("Height Nd Width of zoomRect:\(zoomRect.size.height) \(zoomRect.size.width)")
//        print("Height Nd Width of previewImageView:\(previewImageView.frame.size.height) \(previewImageView.frame.size.width)")
        return zoomRect
    }
    
    @objc private func addTapped() {
        let filterMenu = UIAlertController(title: "Filters", message: "Choose Filter", preferredStyle: .actionSheet)
        let filter1Action = UIAlertAction(title: "Sepia Filter", style: .default) {[weak self] (action) in
            if let imageToEdit = self?.previewImage,
               let originalCIImage = CIImage(image: imageToEdit),
               let sepiaCIImage = self?.sepiaFilter(originalCIImage, intensity:0.9) {
                let capturedImage = UIImage(ciImage: sepiaCIImage, scale: imageToEdit.scale, orientation: imageToEdit.imageOrientation)
                self?.previewImageView.image = capturedImage.fixOrientation()
            }
        }
        let filter2Action = UIAlertAction(title: "Bloom Filter", style: .default) {[weak self] (action) in
            if let imageToEdit = self?.previewImage,
               let originalCIImage = CIImage(image: imageToEdit) ,
               let bloomCIImage = self?.bloomFilter(originalCIImage, intensity: 1, radius: 3) {
                let capturedImage = UIImage(ciImage: bloomCIImage, scale: imageToEdit.scale, orientation: imageToEdit.imageOrientation)
                self?.previewImageView.image = capturedImage.fixOrientation()
            }
        }
        
        let filter3Action = UIAlertAction(title: "Scale Filter", style: .default) {[weak self] (action) in
            if let scaledCIImage = self?.scaleFilter(),
               let imageToEdit = self?.previewImage {
                let capturedImage = UIImage(ciImage: scaledCIImage, scale: imageToEdit.scale, orientation: imageToEdit.imageOrientation)
                self?.previewImageView.image = capturedImage.fixOrientation()
            }
        }
        
        let blurAction = UIAlertAction(title: "Blur Filter", style: .default) { (action) in
           self.blurFilter()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        filterMenu.addAction(filter1Action)
        filterMenu.addAction(filter2Action)
        filterMenu.addAction(filter3Action)
        filterMenu.addAction(blurAction)
        filterMenu.addAction(cancelAction)
    
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverPresentationController = filterMenu.popoverPresentationController {
                popoverPresentationController.permittedArrowDirections = .up
                popoverPresentationController.sourceView = self.view
                popoverPresentationController.sourceRect = CGRect(x: self.view.frame.maxX-50, y: self.view.frame.minY+25, width: 30, height: 30)
                //popoverPresentationController.delegate = self
                filterMenu.modalPresentationStyle = .popover
                present(filterMenu, animated: true, completion: nil)
            }
        } else {
            present(filterMenu, animated: true, completion: nil)
        }
    }
    
    func sepiaFilter(_ input: CIImage, intensity: Double) -> CIImage?
    {
        let sepiaFilter = CIFilter(name:"CISepiaTone")
        sepiaFilter?.setValue(input, forKey: kCIInputImageKey)
        sepiaFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        return sepiaFilter?.outputImage
    }
    
    func bloomFilter(_ input:CIImage, intensity: Double, radius: Double) -> CIImage?
    {
        let bloomFilter = CIFilter(name:"CIBloom")
        bloomFilter?.setValue(input, forKey: kCIInputImageKey)
        bloomFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        bloomFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        return bloomFilter?.outputImage
    }
    
    func scaleFilter() -> CIImage? {
        if let imageToEdit = previewImage {
            let aspectRatio = Double(imageToEdit.size.width) / Double(imageToEdit.size.height)
            let originalCIImage = CIImage(image:imageToEdit)
            let scaleFilter = CIFilter(name:"CILanczosScaleTransform")!
            scaleFilter.setValue(originalCIImage, forKey: kCIInputImageKey)
            scaleFilter.setValue(1, forKey: kCIInputScaleKey)
            scaleFilter.setValue(0.5 * aspectRatio, forKey: kCIInputAspectRatioKey)
            return scaleFilter.outputImage!
        }
        return nil
    }
    
    func blurFilter()
    {
        if let imageToEdit = previewImage {
            let originalCIImage = CIImage(image:imageToEdit)
            let blurFilter = CIFilter(name:"CIBoxBlur")
            blurFilter?.setValue(originalCIImage, forKey: kCIInputImageKey)
            blurFilter?.setValue(5, forKey: kCIInputRadiusKey)
            if let outputImage = blurFilter?.outputImage {
                let capturedImage = UIImage(ciImage: outputImage, scale: imageToEdit.scale, orientation: imageToEdit.imageOrientation)
                previewImageView.image = capturedImage.fixOrientation()
            }
        }
    }
}

// MARK: -
// MARK: Gesture Recongnition
// MARK: -
extension PreviewScreenViewController: UIGestureRecognizerDelegate {
    // This method ensures triple tap gesture cancels double tap gesture's action
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage;
    }

}

