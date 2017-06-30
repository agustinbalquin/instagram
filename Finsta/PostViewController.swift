//
//  PostViewController.swift
//  Finsta
//
//  Created by Agustin Balquin on 6/27/17.
//  Copyright © 2017 Agustin Balquin. All rights reserved.
//

import UIKit
import MBProgressHUD

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelPost(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func setImage(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func sendPost(_ sender: Any) {
        let caption = captionField.text ?? ""
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if imageView.image == nil {
            let alertController = UIAlertController(title: "Post Failed", message: "Image was not selected", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Try Again", style: .default) { (action) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) { }
            
            return
        }
        Post.postUserImage(image: imageView.image, withCaption: caption) { (success: Bool,error: Error?) in
            if success {
//                let alertController = UIAlertController(title: "Success", message: "Image was posted to Instagram", preferredStyle: .alert)
//                
//                // create an OK action
//                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
//                alertController.addAction(OKAction)
//                
//                self.present(alertController, animated: true) { }
                MBProgressHUD.hide(for: self.view, animated: true)
                self.dismiss(animated: true, completion: nil)
                
            } else if let error = error {
                print("Problem posting: \(error.localizedDescription)")
                MBProgressHUD.hide(for: self.view, animated: true)
                
            }
        }
        
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        imageView.image = editedImage

        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }

}
