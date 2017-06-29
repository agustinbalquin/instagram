//
//  ActionCell.swift
//  Finsta
//
//  Created by Agustin Balquin on 6/28/17.
//  Copyright © 2017 Agustin Balquin. All rights reserved.
//

import UIKit
import Parse

class ActionCell: UITableViewCell {

    @IBOutlet weak var likeLabel: UILabel!

    @IBOutlet weak var likeButton: UIButton!
    var liked = false
    
    var imageObject: PFObject? {
        didSet {
            let object = imageObject!
            let likes = object["likesCount"] as! Int
            likeLabel.text = "\(likes) likes"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    @IBAction func likePost(_ sender: Any) {
        let object = imageObject!
        var likes = object["likesCount"] as! Int
        
        if liked == false {
            likes += 1
            likeButton.setImage(UIImage(named: "heartbeating.png"), for: .normal)
            
        } else {
            likes -= 1
            likeButton.setImage(UIImage(named: "heartbeat.png"), for: .normal)
        }
        liked = !liked
        object["likesCount"] = likes
        object.saveInBackground()
        likeLabel.text = "\(likes) likes"
        

    }
    

}
