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

    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var editProfile: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    
    @IBOutlet weak var userLabel: UILabel!
    
    var imageObjects: [PFObject]?
    var user: PFUser?
    
    override func viewWillAppear(_ animated: Bool) {
        onRefresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if user == nil {
            user = PFUser.current()
        }
        onRefresh()
        collectionView.dataSource = self
        userLabel.text = self.user!.username
        if let profileImage = user!["profileImage"] {
            let image = profileImage as! PFFile
            image.getDataInBackground { (imageData:Data!,error: Error?) in
                self.profileImage.image = UIImage(data:imageData)
                self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
            }
        
        }
        
        self.title = user?.username
        
        editProfile.backgroundColor = .clear
        editProfile.layer.cornerRadius = 5
        editProfile.layer.borderWidth = 1
        editProfile.layer.borderColor = UIColor.lightGray.cgColor
        
        settingsButton.backgroundColor = .clear
        settingsButton.layer.cornerRadius = 5
        settingsButton.layer.borderWidth = 1
        settingsButton.layer.borderColor = UIColor.lightGray.cgColor
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)

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
        query.whereKey("author", equalTo: self.user!)
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if posts != nil {
                self.imageObjects = posts
                self.collectionView.reloadData()
                if posts != nil {
                    self.postsLabel.text = String(posts!.count)
                    print("num")
                } else {
                    self.postsLabel.text = "0"
                }
                
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
    
    
    
    // Refresh Control Action
    // ==========================
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.limit = 20
        query.includeKey("author")
        // fetch data asynchronously
        query.whereKey("author", equalTo: self.user!)
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if posts != nil {
                self.imageObjects = posts
                self.collectionView.reloadData()
                refreshControl.endRefreshing()
                if posts != nil {
                    self.postsLabel.text = String(posts!.count)
                    print("num")
                } else {
                    self.postsLabel.text = "0"
                }
                
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
        user["profileImage"] = pffile
        user.saveInBackground()
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }
    
    
   

}
