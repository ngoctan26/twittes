//
//  TweetMainInfoCell.swift
//  Twitters
//
//  Created by Nguyen Quang Ngoc Tan on 3/4/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit

class TweetMainInfoCell: UITableViewCell {
    
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sceenNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.user?.name
            sceenNameLabel.text = "@\((tweet.user?.screenName)!)"
            messageLabel.text = tweet.text
            timeStampLabel.text = tweet.createdAtString
            ImageUtils.loadImageFromUrlWithAnimate(imageView: avatarImg, url: tweet.user?.profileImageUrl)
        }
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
