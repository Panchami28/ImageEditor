//
//  PreviewScreenViewController.swift
//  ImageEditor
//
//  Created by Panchami Rao on 23/03/21.
//

import UIKit
import AVFoundation
import Photos

typealias ImageFilterViewController = UIViewController & IEPreviewProtocol

class PreviewScreenViewController: ImageFilterViewController, UIScrollViewDelegate {
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
    @IBOutlet weak var radiusSlider: UISlider!
    
    @IBOutlet weak var intensitySliderStack: UIStackView!
    @IBOutlet weak var radiusSliderStack: UIStackView!
    
    @IBOutlet weak var compareButton: UIButton!
    
    @IBOutlet weak var clearButton: UIButton!

    var previewImage: UIImage?
    private var imageWithFilter: UIImage?

    private lazy var imageFilterManager = ImageFilterManager()
    private var currentFilterType: IEFilterType = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Preview"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filters", style: .plain, target: self, action: #selector(addFilterButtonClicked))
        previewImageView.image = previewImage
        imageScrollView.delegate = self
        imageViewDoubleTapGestureRecognizer.delegate = self
        imageViewTripleTapGestureRecognizer.delegate = self
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
        let radius = radiusSlider.value
        let intensity = intensitySlider.value
        filterImage(WithIntensity: intensity, radius: radius)
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
        addToGalleryButtonContainer.isHidden = true
        intensitySliderStack.isHidden = true
        radiusSliderStack.isHidden = true
    }
    
//MARK: -
//MARK: - Add image to Library
//MARK: -
    @IBAction func addToGalleryButtonClicked(_ sender: UIButton) {
        if let imageToSave = previewImageView.image {
            UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector(addedImageToLibrary(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        addToGalleryButtonContainer.isHidden = true
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
        let filterMenu = UIAlertController.filterOptionsForImageEditing(sourceViewController: self)
        presentAlertController(filterMenu)
    }

    private func filterImage(WithIntensity intensity: Float = 2.5, radius: Float = 2.5) {
        guard let imageToEdit = previewImage else { return }
        self.imageFilterManager.applyFilter(filterType: currentFilterType, intensity: intensity, radius: radius, onImage: imageToEdit) {[weak self] (displayImage) in
            if let displayImage = displayImage {
                self?.previewImageView.image = displayImage
            }
        }
    }
    
    func resetSliders() {
        intensitySlider.value = 3
        radiusSlider.value = 3
    }

    func applyFilter(_ filterType: IEFilterType) {
        resetSliders()
        currentFilterType = filterType
        intensitySliderStack.isHidden = !filterType.hasIntensity
        radiusSliderStack.isHidden = !filterType.hasRadius
        addToGalleryButtonContainer.isHidden = false
        filterImage()
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



