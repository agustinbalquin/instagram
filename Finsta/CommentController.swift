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
            print("its getting here")
            let comment = comments![indexPath.row]
            cell.commentLabel.text = comment["caption"] as! String
            let user = comment["author"] as! PFUser
            cell.userLabel.text = user.username
            cell.timeSinceLabel.text = comment.createdAt?.getElapsedInterval()
        }
        return cell
    }
    
    
    @IBAction func sendComment(_ sender: Any) {
        let caption = commentField.text
        Comment.postComment(post: self.post!, withCaption: caption) { (success: Bool, error: Error?) in
            print("commentPosted")
            
            var commentNum = self.post!["commentsCount"] as! Int
            commentNum += 1
            self.post!["commentsCount"] = commentNum
            self.post!.saveInBackground()
            print("commentPosted")
        }

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
