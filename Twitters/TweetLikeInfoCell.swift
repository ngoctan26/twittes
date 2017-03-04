//
//  TweetLikeInfoCell.swift
//  Twitters
//
//  Created by Nguyen Quang Ngoc Tan on 3/4/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit

class TweetLikeInfoCell: UITableViewCell {
    
    @IBOutlet weak var retweetNo: UILabel!
    @IBOutlet weak var likeNo: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
