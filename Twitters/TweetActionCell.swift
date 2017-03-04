//
//  TweetActionCell.swift
//  Twitters
//
//  Created by Nguyen Quang Ngoc Tan on 3/4/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit

class TweetActionCell: UITableViewCell {
    
    @IBOutlet weak var btnFav: UIButton!
    
    @IBAction func replyClicked(_ sender: Any) {
    }
    
    
    @IBAction func retweetClicked(_ sender: Any) {
    }

    @IBAction func favClicked(_ sender: Any) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
