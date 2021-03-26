//
//  MyImagePickerController.swift
//  ImageEditor
//
//  Created by Panchami Rao on 23/03/21.
//

import UIKit

class MyImagePickerController: UIImagePickerController {
    
    static func instantiate() -> MyImagePickerController {
        let myImagePickerVC = MyImagePickerController()
        myImagePickerVC.sourceType = .camera
        myImagePickerVC.showsCameraControls = true
        myImagePickerVC.allowsEditing = false
        return myImagePickerVC
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
