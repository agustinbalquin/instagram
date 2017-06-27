//
//  PhotoMapViewController.swift
//  Finsta
//
//  Created by Agustin Balquin on 6/27/17.
//  Copyright © 2017 Agustin Balquin. All rights reserved.
//

import UIKit
import Parse

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  UITableViewDataSource,  UITableViewDelegate {

    
    
//    Outlets
//    ==================
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var imageObjects: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if imageObjects == nil{
            return 0
        }
        return imageObjects!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! ImagePostCell
        let object = imageObjects![indexPath.row]
        let message = object["text"] as? String
        if let user = object["user"] as? PFUser {
            cell.usernameLabel.text = user.username
        } else {
            cell.usernameLabel.text = "No Name"
        }
        cell.captionLabel.text = message
        return cell
    }

    
    
    
    
    
    @IBAction func postPhoto(_ sender: Any) {
        print("postImage")
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
    
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        let caption = "Temporary Caption"
        
        Post.postUserImage(image: editedImage, withCaption: caption) { (success: Bool,error: Error?) in
            if success {
                print("Posted to Instagram!")
                
            } else if let error = error {
                print("Problem posting: \(error.localizedDescription)")
            }
        }
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    

}
