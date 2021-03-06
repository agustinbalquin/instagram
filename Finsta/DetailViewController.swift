//
//  DetailViewController.swift
//  Finsta
//
//  Created by Agustin Balquin on 6/27/17.
//  Copyright © 2017 Agustin Balquin. All rights reserved.
//

import UIKit
import Parse

class DetailViewController: UIViewController {

    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    
    var imageObject: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let message = imageObject!["caption"] as! String
        let image = imageObject!["media"] as! PFFile
        if let date = imageObject!.createdAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            let dateString = dateFormatter.string(from: date)
            dateLabel.text = dateString // Prints: Jun 28, 2017, 2:08 PM
        }

        captionLabel.text = message
        image.getDataInBackground { (imageData:Data!,error: Error?) in
            self.detailImage.image = UIImage(data:imageData)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
