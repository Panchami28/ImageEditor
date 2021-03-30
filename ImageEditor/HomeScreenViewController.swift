//
//  HomeScreenViewController.swift
//  ImageEditor
//
//  Created by Panchami Rao on 23/03/21.
//

import UIKit
import Photos

class HomeScreenViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let myImagePickerVC = MyImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myImagePickerVC.delegate = self
    }
    //MARK: -
    //MARK: - IB Actions
    //MARK: -
    
    @IBAction func choosePhotoButtonClicked(_ sender: UIButton) {
        myImagePickerVC.optionType = .gallery
        myImagePickerVC.instantiate()
        present(myImagePickerVC, animated: true)
    }
    
    @IBAction func captureButtonClicked(_ sender: UIButton) {
        myImagePickerVC.optionType = .camera
        myImagePickerVC.instantiate()
        present(myImagePickerVC, animated: true)
    }
    
    //MARK: -
    //MARK: - Functions
    //MARK: -
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true) {
            if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                if self.myImagePickerVC.optionType == .camera {
                    UIImageWriteToSavedPhotosAlbum(img, self, #selector(self.addedImageToLibrary(_:didFinishSavingWithError:contextInfo:)), nil)
                }
                self.loadData(image: img)
            }
        }
    }
    
    func loadData(image:UIImage) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let previewScreenViewController = storyboard.instantiateViewController(identifier: "PreviewScreenViewController") as? PreviewScreenViewController {
            previewScreenViewController.previewImage = image
            self.navigationController?.pushViewController(previewScreenViewController, animated: true)
        }
    }
    
    //MARK: -
    //MARK: - Add image to Library
    //MARK: -
    @objc func addedImageToLibrary(_ image: UIImage,didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if let error = error {
                // we got back an error!
                let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            } else {
                let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
}
