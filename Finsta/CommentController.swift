//
//  CommentController.swift
//  Finsta
//
//  Created by Agustin Balquin on 6/29/17.
//  Copyright © 2017 Agustin Balquin. All rights reserved.
//

import UIKit
import Parse

class CommentController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentField: UITextField!
    var post:PFObject? {
        didSet{
            self.comments = post!["comments"] as? [PFObject]
        }
    }
    var comments:[PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onRefresh()

        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.reloadData()
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            print("Did show")
            let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            self.bottomConstraint.constant = frame.height
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            print("Did Hide")
            let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            self.bottomConstraint.constant = 0//frame.height
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // Table View 
    // ============== 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if post == nil{
            return 0
        }
        
        return post!["commentsCount"] as! Int
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
        if comments != nil {
            let comment = comments![indexPath.row]
            cell.commentLabel.text = comment["caption"] as! String
            let user = comment["author"] as! PFUser
            cell.userLabel.text = user.username
            cell.timeSinceLabel.text = comment.createdAt?.getElapsedInterval()
        }
        return cell
    }
    
    
    
    @IBAction func closeKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    @IBAction func sendComment(_ sender: Any) {
        if fieldCheck() {
            let caption = commentField.text
            Comment.postComment(post: self.post!, withCaption: caption) { (success: Bool, error: Error?) in
                print("commentPosted")
                
                var commentNum = self.post!["commentsCount"] as! Int
                commentNum += 1
                self.post!["commentsCount"] = commentNum
                self.post!.saveInBackground()
                print("commentPosted")
                self.onRefresh()
                self.commentField.text = ""
            }
        }

    }
    
    func fieldCheck() -> Bool{
        if commentField.text!.isEmpty {
            let alertController = UIAlertController(title: "Error", message: "Comment Field  is empty", preferredStyle: .alert)
            
            // create an OK action
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // handle response here.
            }
            alertController.addAction(OKAction)
            
            present(alertController, animated: true) {
            
            }
            return false
        }
        return true

    }
    
    // On Refresh
    // =================
    func onRefresh() {
        let query = PFQuery(className: "Comment")
        query.addDescendingOrder("createdAt")
        query.limit = 20
        query.includeKey("author")
        // fetch data asynchronously
        query.whereKey("post", equalTo: self.post!)
        query.findObjectsInBackground { (comments: [PFObject]?, error: Error?) in
            if comments != nil {
                self.comments = comments
                self.commentTableView.reloadData()
                
            } else {
                print(error?.localizedDescription ?? "General Error")
            }
        }
    }
    
}
