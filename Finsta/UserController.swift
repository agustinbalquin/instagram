//
//  UserController.swift
//  Finsta
//
//  Created by Agustin Balquin on 6/28/17.
//  Copyright © 2017 Agustin Balquin. All rights reserved.
//

import UIKit
import Parse

class UserController: UIViewController, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var userLabel: UILabel!
    
    var imageObjects: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        userLabel.text = PFUser.current()?.username
        let user = PFUser.current()
        if let profileImage = user!["profileImage"] {
            let image = profileImage as! PFFile
            image.getDataInBackground { (imageData:Data!,error: Error?) in
                self.profileImage.image = UIImage(data:imageData)
                self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
            }
        
        }
        
        
        onRefresh()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Collection View
    // ==================
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageObjects != nil {
            return imageObjects!.count
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCollection", for: indexPath) as! UserCollectionViewCell
        
        let object = imageObjects![indexPath.item]
        
        
        let image = object["media"] as! PFFile
        image.getDataInBackground { (imageData:Data!,error: Error?) in
            cell.userImage.image = UIImage(data:imageData)
        }
        
        return cell
    }
    
    // On refresh
    // =======================
    func onRefresh() {
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.limit = 20
        query.includeKey("author")
        // fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if posts != nil {
                self.imageObjects = posts
                self.collectionView.reloadData()
                
            } else {
                print(error?.localizedDescription ?? "General Error")
            }
        }
    }
    
    
    
    // On Query
    // =====================
    func onQuery() {
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.limit = 20
        query.includeKey("author")
        // fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if posts != nil {
                for post in posts! {
                    self.imageObjects!.append(post)
                }
                self.collectionView.reloadData()
                
            } else {
                print(error?.localizedDescription ?? "General Error")
            }
        }
    }
    

    
    // Change Profile Picture
    // ========================
    
    @IBAction func changeProfileImage(_ sender: Any) {
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
        profileImage.image = editedImage
        
        let pffile = Post.getPFFileFromImage(image: editedImage)
        let user = PFUser.current()!
        user.saveInBackground()
        user["profileImage"] = pffile
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    
   

}
