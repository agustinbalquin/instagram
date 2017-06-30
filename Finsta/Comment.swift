//
//  Comment.swift
//  Finsta
//
//  Created by Agustin Balquin on 6/29/17.
//  Copyright © 2017 Agustin Balquin. All rights reserved.
//

import Foundation
import Parse


class Comment: NSObject {
    /**
     * Other methods
     */
    
    /**
     Method to add a user post to Parse (uploading image file)
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func postComment(post: PFObject, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let comment = PFObject(className: "Comment")
        
        // Add relevant fields to the object
        comment["author"] = PFUser.current() // Pointer column type that points to PFUser
        comment["caption"] = caption
        comment["likesCount"] = 0
        comment["post"] = post
        
        // Save object (following function will save the object in Parse asynchronously)
        comment.saveInBackground(block: completion)
    }
    

   
}
