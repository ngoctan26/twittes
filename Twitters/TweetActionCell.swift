//
//  TweetActionCell.swift
//  Twitters
//
//  Created by Nguyen Quang Ngoc Tan on 3/4/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit

@objc protocol TweetActionCellDelegate {
    @objc optional func onBtnFavouriteClicked()
    @objc optional func onBtnRetweetClicked()
}

class TweetActionCell: UITableViewCell {
    
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var btnRetweet: UIButton!
    
    
    // Properties
    var vcDelegate: TweetActionCellDelegate!
    
    @IBAction func replyClicked(_ sender: Any) {
    }
    
    
    @IBAction func retweetClicked(_ sender: Any) {
        vcDelegate.onBtnRetweetClicked!()
    }

    @IBAction func favClicked(_ sender: Any) {
        vcDelegate.onBtnFavouriteClicked!()
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
