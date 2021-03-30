//
//  MyImagePickerController.swift
//  ImageEditor
//
//  Created by Panchami Rao on 23/03/21.
//

import UIKit

enum typeOfOption {
    case camera
    case gallery
}

class MyImagePickerController: UIImagePickerController {
    
    var optionType: typeOfOption = .camera
    
    func instantiate() {
        switch optionType {
        case .camera: sourceType = .camera
            showsCameraControls = true
        case .gallery: sourceType = .photoLibrary
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
