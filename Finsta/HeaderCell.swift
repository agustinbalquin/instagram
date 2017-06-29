//
//  HeaderCell.swift
//  Finsta
//
//  Created by Agustin Balquin on 6/28/17.
//  Copyright © 2017 Agustin Balquin. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {
    
    @IBOutlet weak var userPhoto: UIImageView!

    @IBOutlet weak var usernameButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func userLink(_ sender: Any) {
        
    }
    
}
