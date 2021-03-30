//
//  PreviewScreenViewController.swift
//  ImageEditor
//
//  Created by Panchami Rao on 23/03/21.
//

import UIKit
import AVFoundation
import Photos

class PreviewScreenViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet var imageViewDoubleTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var imageViewTripleTapGestureRecognizer: UITapGestureRecognizer!
    
    var previewImage: UIImage?
    var requiredAsset: PHAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Preview"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filters", style: .plain, target: self, action: #selector(addFilterButtonClicked))
        previewImageView.image = previewImage
        imageScrollView.delegate = self
        imageViewDoubleTapGestureRecognizer.delegate = self
        imageViewTripleTapGestureRecognizer.delegate = self
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
    
//MARK: -
//MARK: - Add image to Library
//MARK: -
    @IBAction func addToGalleryButtonClicked(_ sender: UIButton) {
        if let imageToSave = previewImageView.image {
            UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector(addImageToLibrary(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc func addImageToLibrary(_ image: UIImage,didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if let error = error {
                // we got back an error!
                let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            } else {
                let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
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
        return zoomRect
    }
    
    
    @objc private func addFilterButtonClicked() {
        let filterMenu = UIAlertController(title: "Filters", message: "", preferredStyle: .actionSheet)
        let colorFilterAction = UIAlertAction(title: "Color Filters", style: .default) { [weak self] (action) in
            let colorFilterMenu = UIAlertController(title: "", message: "Choose required Color Filter", preferredStyle: .actionSheet)
            let sepiaFilterAction = UIAlertAction(title: "Sepia Filter", style: .default) {[weak self] (action) in
                if let imageInCIFormat = self?.convertToCIImage(),
                   let sepiaCIImage = self?.sepiaFilter(imageInCIFormat, intensity:0.9) {
                    self?.displayFilteredImage(imageToDisplay: sepiaCIImage)
                }
            }
            let photoFilterAction = UIAlertAction(title: "Photo Effect Transfer Filter", style: .default) { [weak self] (action) in
                if let imageInCIFormat = self?.convertToCIImage(),
                   let photoFilterCIImage = self?.photoEffectFilter(imageInCIFormat) {
                    self?.displayFilteredImage(imageToDisplay: photoFilterCIImage)
                }
            }
            colorFilterMenu.addAction(sepiaFilterAction)
            colorFilterMenu.addAction(photoFilterAction)
            self?.presentAlertController(colorFilterMenu)
        }
        
        let styleFilterAction = UIAlertAction(title: "Style Filters", style: .default) { [weak self] (action) in
            let styleFilterMenu = UIAlertController(title: "", message: "Choose required Style Filter", preferredStyle: .actionSheet)
            let bloomFilterAction = UIAlertAction(title: "Bloom Filter", style: .default) {[weak self] (action) in
                if let imageInCIFormat = self?.convertToCIImage(),
                   let bloomCIImage = self?.bloomFilter(imageInCIFormat, intensity: 3, radius: 3) {
                    self?.displayFilteredImage(imageToDisplay: bloomCIImage)
                }
            }
            let gloomFilterAction = UIAlertAction(title: "Gloom Filter", style: .default) {[weak self] (action) in
                if let imageInCIFormat = self?.convertToCIImage(),
                   let gloomCIImage = self?.gloomFilter(imageInCIFormat, intensity: 3, radius: 3) {
                    self?.displayFilteredImage(imageToDisplay: gloomCIImage)
                }
            }
            styleFilterMenu.addAction(bloomFilterAction)
            styleFilterMenu.addAction(gloomFilterAction)
            self?.presentAlertController(styleFilterMenu)
        }
        
        let blurFilterAction = UIAlertAction(title: "Blur Filters", style: .default) {[weak self] (action) in
            let blurFilterMenu = UIAlertController(title: "", message: "Choose required Blur Filter", preferredStyle: .actionSheet)
            let rectangularBlurAction = UIAlertAction(title: "Rectangular Blur", style: .default) { (action) in
                if let blurredImage = self?.blurFilter() {
                    self?.displayFilteredImage(imageToDisplay: blurredImage)
                }
            }
            let discBlurAction = UIAlertAction(title: "Disc Blur", style: .default) {[weak self] (action) in
                if let discBlurredImage = self?.discFilter() {
                    self?.displayFilteredImage(imageToDisplay: discBlurredImage)
                }
            }
            blurFilterMenu.addAction(rectangularBlurAction)
            blurFilterMenu.addAction(discBlurAction)
            self?.presentAlertController(blurFilterMenu)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        filterMenu.addAction(colorFilterAction)
        filterMenu.addAction(styleFilterAction)
        filterMenu.addAction(blurFilterAction)
        filterMenu.addAction(cancelAction)
        presentAlertController(filterMenu)
        
    }
    
    func presentAlertController(_ menuToPresent: UIAlertController) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverPresentationController = menuToPresent.popoverPresentationController {
                popoverPresentationController.permittedArrowDirections = .up
                popoverPresentationController.sourceView = self.view
                popoverPresentationController.sourceRect = CGRect(x: self.view.frame.maxX-50, y: self.view.frame.minY+25, width: 30, height: 30)
                menuToPresent.modalPresentationStyle = .popover
                present(menuToPresent, animated: true, completion: nil)
            }
        } else {
            present(menuToPresent, animated: true, completion: nil)
        }
    }
    
    func convertToCIImage()->CIImage?
    {
        if let imageToEdit = previewImage {
           let originalCIImage = CIImage(image: imageToEdit)
            return originalCIImage
        }
        return nil
    }
    
    func displayFilteredImage(imageToDisplay : CIImage?){
        if let imageToEdit = previewImage,
         let imageToBeDisplayed = imageToDisplay {
            let capturedImage = UIImage(ciImage: imageToBeDisplayed, scale: imageToEdit.scale, orientation: imageToEdit.imageOrientation)
            previewImageView.image = capturedImage.fixOrientation()
        }
    }
//MARK: -
//MARK: - Filter Methods
//MARK: -
    
    func sepiaFilter(_ input: CIImage, intensity: Double) -> CIImage?
    {
        let sepiaFilter = CIFilter(name:"CISepiaTone")
        sepiaFilter?.setValue(input, forKey: kCIInputImageKey)
        sepiaFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        return sepiaFilter?.outputImage
    }
    
    func photoEffectFilter(_ input:CIImage) -> CIImage? {
        let photoFilter = CIFilter(name:"CIPhotoEffectTransfer")
        photoFilter?.setValue(input, forKey: kCIInputImageKey)
        return photoFilter?.outputImage
    }
    
    func bloomFilter(_ input:CIImage, intensity: Double, radius: Double) -> CIImage? {
        let bloomFilter = CIFilter(name:"CIBloom")
        bloomFilter?.setValue(input, forKey: kCIInputImageKey)
        bloomFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        bloomFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        return bloomFilter?.outputImage
    }
    
    func gloomFilter(_ input:CIImage, intensity: Double, radius: Double) -> CIImage? {
        let gloomFilter = CIFilter(name:"CIGloom")
        gloomFilter?.setValue(input, forKey: kCIInputImageKey)
        gloomFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        gloomFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        return gloomFilter?.outputImage
    }
    
    func blurFilter() -> CIImage?
    {
        if let imageToEdit = previewImage {
            let originalCIImage = CIImage(image:imageToEdit)
            let blurFilter = CIFilter(name:"CIBoxBlur")
            blurFilter?.setValue(originalCIImage, forKey: kCIInputImageKey)
            blurFilter?.setValue(5, forKey: kCIInputRadiusKey)
            return blurFilter?.outputImage!
        }
        return nil
    }
    
    func discFilter() -> CIImage?
    {
        if let imageToEdit = previewImage {
            let originalCIImage = CIImage(image:imageToEdit)
            let discFilter = CIFilter(name:"CIDiscBlur")
            discFilter?.setValue(originalCIImage, forKey: kCIInputImageKey)
            discFilter?.setValue(5, forKey: kCIInputRadiusKey)
            return discFilter?.outputImage!
        }
        return nil
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
        return normalizedImage;
    }

}

