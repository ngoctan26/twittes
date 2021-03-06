//
//  TweetCell.swift
//  Twitters
//
//  Created by Nguyen Quang Ngoc Tan on 3/3/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate {
    @objc optional func onFavouriteBtnClicked(id: String, position: Int)
    @objc optional func onRetweetBtnClicked(id: String, position: Int)
}

class TweetCell: UITableViewCell {
    // View references
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var mediaImage: UIImageView!
    @IBOutlet weak var btnRetweet: UIButton!
    
    @IBOutlet weak var imageHeightConstrain: NSLayoutConstraint!
    
    // Properties
    var position: Int!
    weak var vcDelegate: TweetCellDelegate!
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.user?.name
            accountLabel.text = "@" + (tweet.user?.screenName)!
            tweetLabel.text = tweet.text
            timeStampLabel.text = tweet.timeSinceCreated
            ImageUtils.loadImageFromUrlWithAnimate(imageView: avatarImage, url: (tweet.user?.profileImageUrl))
            if tweet.favourited {
                btnFavourite.setImage(#imageLiteral(resourceName: "ic_gold_star"), for: UIControlState.normal)
            } else {
                btnFavourite.setImage(#imageLiteral(resourceName: "ic_grey_star"), for: UIControlState.normal)
            }
            if tweet.retweeted {
                btnRetweet.setImage(#imageLiteral(resourceName: "ic_retweet_green"), for: UIControlState.normal)
            } else {
                btnRetweet.setImage(#imageLiteral(resourceName: "ic_retweet"), for: UIControlState.normal)
            }
            if let mediaUrl = tweet.mediaUrl {
                ImageUtils.loadImageFromUrlWithAnimate(imageView: mediaImage, url: mediaUrl)
            } else {
                imageHeightConstrain.constant = 0
            }
        }
    }
    
    // Actions
    @IBAction func replyBtnClicked(_ sender: UIButton) {
    }
    
    @IBAction func retweetBtnClicked(_ sender: UIButton) {
        vcDelegate.onRetweetBtnClicked!(id: tweet.id!, position: position)
    }
    
    @IBAction func favBtnClicked(_ sender: UIButton) {
        vcDelegate.onFavouriteBtnClicked!(id: tweet.id!, position: position)
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
