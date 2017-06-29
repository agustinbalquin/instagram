//
//  CaptionCell.swift
//  Finsta
//
//  Created by Agustin Balquin on 6/29/17.
//  Copyright © 2017 Agustin Balquin. All rights reserved.
//

import UIKit

class CaptionCell: UITableViewCell {
    @IBOutlet weak var timeSinceLabel: UILabel!

    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
