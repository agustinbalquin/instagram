//
//  PhotoMapViewController.swift
//  Finsta
//
//  Created by Agustin Balquin on 6/27/17.
//  Copyright © 2017 Agustin Balquin. All rights reserved.
//

import UIKit
import Parse

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate  {

    
    
    // Outlets
    // ==================
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var imageObjects: [PFObject]?
    var isMoreDataLoading = false
    var photoHeaderViewHeight:CGFloat = 45
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.onRefresh()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // TableView
    // ==============
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if imageObjects == nil{
            return 0
        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if imageObjects == nil{
            return 0
        }
        print("numsecs \(imageObjects!.count)")
        return imageObjects!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! ImagePostCell
        let object = imageObjects![indexPath.section]
        let message = object["caption"] as! String
        let image = object["media"] as! PFFile
        
        image.getDataInBackground { (imageData:Data!,error: Error?) in
            cell.imagePost.image = UIImage(data:imageData)
        }
        cell.captionLabel.text = message
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCell
        let object = imageObjects![section]
        if let user = object["author"] as? PFUser {
            cell.usernameLabel.text = user.username
        } else {
            cell.usernameLabel.text = "No Name"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return photoHeaderViewHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
                self.tableView.reloadData()
                
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
                self.tableView.reloadData()

            } else {
                print(error?.localizedDescription ?? "General Error")
            }
        }
    }
    
    
    
    
    
    
    // Prepare for Segue
    // =================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "postSegue" {
            let cell =  sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                let object = imageObjects![indexPath.row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.imageObject = object
            }
        }
    }
    
    
    
    
    
    
    // Infinite Scroll
    // ====================
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                print("Please help me")
               onQuery()
            }
        }
    }
    
    
    
    
    
    
    
    

    
    
    
    
    // Refresh Control
    // ===============
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.limit = 20
        query.includeKey("author")
        // fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if posts != nil {
                self.imageObjects = posts
                self.tableView.reloadData()
                refreshControl.endRefreshing()
                
            } else {
                print(error?.localizedDescription ?? "General Error")
            }
        }
    }

    // Image Posting
    // ================
    
    @IBAction func postPhoto(_ sender: Any) {
        performSegue(withIdentifier: "postSegue", sender: nil)
    }
    
    
    // Sign Out
    // ==============
    @IBAction func signOut(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in }
        NotificationCenter.default.post(name: NSNotification.Name("logoutNotfication"),object: nil)
    }
    
    
    

    

}
