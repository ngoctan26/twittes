//
//  TweetDetailViewController.swift
//  Twitters
//
//  Created by Nguyen Quang Ngoc Tan on 3/3/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit

@objc protocol TweetDetailViewControllerDelegate {
    @objc optional func onTweetDetailUpdate(position: Int, updatedTweet: Tweet)
}

class TweetDetailViewController: UIViewController {
    //View references
    @IBOutlet weak var tableView: UITableView!
    
    // properties
    var tweetDetail: Tweet!
    var position: Int!
    weak var vcDelegate: TweetDetailViewControllerDelegate!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: .zero)
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

extension TweetDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "tweetMainCell", for: indexPath) as! TweetMainInfoCell
            cell.tweet = tweetDetail
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "tweetLikeCell", for: indexPath) as! TweetLikeInfoCell
            cell.likeNo.text = String(tweetDetail.favCount)
            cell.retweetNo.text = String(tweetDetail.retweetCount)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "tweetActionCell", for: indexPath) as! TweetActionCell
            cell.vcDelegate = self
            if tweetDetail.favourited {
                cell.btnFav.setImage(#imageLiteral(resourceName: "ic_gold_star"), for: UIControlState.normal)
            } else {
                cell.btnFav.setImage(#imageLiteral(resourceName: "ic_grey_star"), for: UIControlState.normal)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension TweetDetailViewController: TweetActionCellDelegate {
    func onBtnFavouriteClicked() {
        let client = TwitterClient.instance!
        if tweetDetail.favourited {
            client.destroyFavourite(id: tweetDetail.id!, failure: { (error) in
                print("Destroy favourite from detail view failed: \(error?.localizedDescription)")
            }, success: { (updatedTweet) in
                self.tweetDetail = updatedTweet
                self.vcDelegate.onTweetDetailUpdate!(position: self.position, updatedTweet: updatedTweet)
                self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)], with: UITableViewRowAnimation.automatic)
            })
        } else {
            client.createFavourite(id: tweetDetail.id!, failure: { (error) in
                print("Update favourite from detail view failed: \(error?.localizedDescription)")
            }, success: { (updatedTweet) in
                self.tweetDetail = updatedTweet
                self.vcDelegate.onTweetDetailUpdate!(position: self.position, updatedTweet: updatedTweet)
                self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0), IndexPath(row: 2, section: 0)], with: UITableViewRowAnimation.automatic)
            })
        }
    }
}
