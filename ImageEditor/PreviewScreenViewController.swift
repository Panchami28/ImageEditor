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
    
// MARK: -
// MARK: IB Outlets
// MARK: -
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet var imageViewDoubleTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var imageViewTripleTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var addToGalleryButton: UIButton!
    @IBOutlet weak var addToGalleryButtonContainer: UIView!
    @IBOutlet weak var intensitySlider: UISlider!
    
    var previewImage: UIImage?
    var callingFilter = "sepia"
    var filterApplyingQueue = DispatchQueue(label: "ImageFilterQueue")
    let imageFilterManager = ImageFilterManager()
    var imageWithFilter: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Preview"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filters", style: .plain, target: self, action: #selector(addFilterButtonClicked))
        previewImageView.image = previewImage
        imageScrollView.delegate = self
        imageViewDoubleTapGestureRecognizer.delegate = self
        imageViewTripleTapGestureRecognizer.delegate = self
        addToGalleryButton.isHidden = true
        addToGalleryButtonContainer.isHidden = true
        updateSlider(isHidden: true)
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
    }
    
    
    @IBAction func tripleTapImage(_ sender: UITapGestureRecognizer) {
        if imageScrollView.zoomScale == imageScrollView.minimumZoomScale {
            imageScrollView.zoom(to: zoomRectangle(scale: imageScrollView.maximumZoomScale, center: sender.location(in: sender.view)), animated: true)
            } else {
                imageScrollView.setZoomScale(imageScrollView.minimumZoomScale, animated: true)
            }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let changedIntensityValue = intensitySlider.value
        var filteredImage : CIImage?
        filterApplyingQueue.async { [weak self] in
            if let inputUIImage = self?.previewImage {
                if self?.callingFilter == "bloom" {
                    filteredImage = self?.imageFilterManager.bloomFilter(inputUIImage, intensity: Double(changedIntensityValue), radius: 3)
                }
                else if self?.callingFilter == "gloom" {
                    filteredImage = self?.imageFilterManager.gloomFilter(inputUIImage, intensity: Double(changedIntensityValue), radius: 3)
                }
                else if self?.callingFilter == "sepia" {
                    filteredImage = self?.imageFilterManager.sepiaFilter(inputUIImage, intensity: Double(changedIntensityValue))
                }
                DispatchQueue.main.async {
                    self?.displayFilteredImage(imageToDisplay: filteredImage)
                }
            }
        }
    }
    
    @IBAction func compareButtonPressed(_ sender: UIButton) {
        imageWithFilter = previewImageView.image
        previewImageView.image = previewImage
    }
    
    @IBAction func compareButtonReleased(_ sender: UIButton) {
        previewImageView.image = imageWithFilter
    }
    
    
    @IBAction func removeFilterButtonClicked(_ sender: UIButton) {
        previewImageView.image = previewImage
        addToGalleryButton.isHidden = true
        addToGalleryButtonContainer.isHidden = true
        updateSlider(isHidden: true)
    }
    
//MARK: -
//MARK: - Add image to Library
//MARK: -
    @IBAction func addToGalleryButtonClicked(_ sender: UIButton) {
        if let imageToSave = previewImageView.image {
            UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector(addedImageToLibrary(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        addToGalleryButton.isHidden = true
        addToGalleryButtonContainer.isHidden = true
        updateSlider(isHidden: true)
    }
    
    @objc func addedImageToLibrary(_ image: UIImage,didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
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
// MARK: Delegate Method for zooming on pinch
// MARK: -
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return previewImageView
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
                self?.updateSlider(isHidden: false)
                self?.callingFilter = "sepia"
                if let inputUIImage = self?.previewImage,
                let sepiaCIImage = self?.imageFilterManager.sepiaFilter(inputUIImage, intensity:Double(self?.intensitySlider.value ?? 0)) {
                    self?.displayFilteredImage(imageToDisplay: sepiaCIImage)
                }
            }
            let photoFilterAction = UIAlertAction(title: "Photo Effect Transfer Filter", style: .default) { [weak self] (action) in
                self?.updateSlider(isHidden: true)
                if let inputUIImage = self?.previewImage,
                   let photoFilterCIImage = self?.imageFilterManager.photoEffectFilter(inputUIImage) {
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
                self?.updateSlider(isHidden: false)
                self?.callingFilter = "bloom"
                if let inputUIImage = self?.previewImage,
                   let bloomCIImage = self?.imageFilterManager.bloomFilter(inputUIImage, intensity: Double(self?.intensitySlider.value ?? 0), radius: 3) {
                    self?.displayFilteredImage(imageToDisplay: bloomCIImage)
                }
            }
            let gloomFilterAction = UIAlertAction(title: "Gloom Filter", style: .default) {[weak self] (action) in
                self?.updateSlider(isHidden: false)
                self?.callingFilter = "gloom"
                if let inputUIImage = self?.previewImage,
                   let gloomCIImage = self?.imageFilterManager.gloomFilter(inputUIImage, intensity: Double(self?.intensitySlider.value ?? 0), radius: 3) {
                    self?.displayFilteredImage(imageToDisplay: gloomCIImage)
                }
            }
            styleFilterMenu.addAction(bloomFilterAction)
            styleFilterMenu.addAction(gloomFilterAction)
            self?.presentAlertController(styleFilterMenu)
        }
        
        let blurFilterAction = UIAlertAction(title: "Blur Filters", style: .default) {[weak self] (action) in
            self?.updateSlider(isHidden: true)
            let blurFilterMenu = UIAlertController(title: "", message: "Choose required Blur Filter", preferredStyle: .actionSheet)
            let rectangularBlurAction = UIAlertAction(title: "Rectangular Blur", style: .default) {(action) in
                if let inputUIImage = self?.previewImage,
                   let blurredImage = self?.imageFilterManager.rectangularBlurFilter(inputUIImage) {
                    self?.displayFilteredImage(imageToDisplay: blurredImage)
                }
            }
            let discBlurAction = UIAlertAction(title: "Disc Blur", style: .default) {[weak self] (action) in
                if let inputUIImage = self?.previewImage,
                   let blurredImage = self?.imageFilterManager.discBlurFilter(inputUIImage) {
                    self?.displayFilteredImage(imageToDisplay: blurredImage)
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
    
    func displayFilteredImage(imageToDisplay : CIImage?) {
        if let imageToEdit = previewImage,
           let imageToBeDisplayed = imageToDisplay {
            let capturedImage = UIImage(ciImage: imageToBeDisplayed, scale: imageToEdit.scale, orientation: imageToEdit.imageOrientation)
            previewImageView.image = capturedImage.fixOrientation()
            addToGalleryButton.isHidden = false
            addToGalleryButtonContainer.isHidden = false
        }
    }
    
    func updateSlider(isHidden value: Bool) {
        switch value {
        case true : intensitySlider.isHidden = true
        case false : intensitySlider.isHidden = false
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

