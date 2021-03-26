//
//  HomeScreenViewController.swift
//  ImageEditor
//
//  Created by Panchami Rao on 23/03/21.
//

import UIKit

class HomeScreenViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func captureButtonClicked(_ sender: UIButton) {
        let myImagePickerVC = MyImagePickerController.instantiate()
        myImagePickerVC.delegate = self
        present(myImagePickerVC, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true) {
            if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                if let previewScreenViewController = storyboard.instantiateViewController(identifier: "PreviewScreenViewController") as? PreviewScreenViewController {
                    previewScreenViewController.previewImage = img
                    self.navigationController?.pushViewController(previewScreenViewController, animated: true)
                }
            }
        }
    }

}
