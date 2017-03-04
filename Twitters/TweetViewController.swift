//
//  TweetViewController.swift
//  Twitters
//
//  Created by Nguyen Quang Ngoc Tan on 3/2/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit
import MBProgressHUD

class TweetViewController: UIViewController {
    // View reference
    @IBOutlet weak var tableView: UITableView!
    var refreshController = UIRefreshControl()
    
    // Properties
    var selectedIndex: Int!
    var currentPage = 0
    var isMoreDataLoading = false
    var tweets = [Tweet]()
    
    //Actions
    @IBAction func logoutBtnClicked(_ sender: UIBarButtonItem) {
        SettingUtils.removeSetting(key: "save-token")
        TwitterClient.instance?.deauthorize()
        moveToLoginVC()
    }
    
    @IBAction func newBtnClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "newTweet", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        loadData(paging: currentPage, isRefresh: false)
    }
    
    func initView() {
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        refreshController.addTarget(self, action:  #selector(refreshData), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshController)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData() {
        loadData(paging: currentPage, isRefresh: true)
    }
    
    func loadData(paging: Int, isRefresh: Bool) {
        if !isRefresh {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        refreshController.endRefreshing()
        TwitterClient.instance?.homeTimeline(paging: currentPage, completion: { (error, tweets) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.isMoreDataLoading = false
            if error != nil {
                return
            }
            self.tweets = tweets!
            self.currentPage += self.tweets.count
            self.tableView.reloadData()
        })
    }

    func moveToLoginVC() {
        // Move to tweet vc
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        present(loginVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let destinationVC = segue.destination as? TweetDetailViewController
            if let destinationVC = destinationVC {
                destinationVC.tweetDetail = tweets[selectedIndex]
                destinationVC.position = selectedIndex
            }
        } else if segue.identifier == "newTweet" {
            let destinationVC = segue.destination as? NewTweetViewController
            if let destinationVC = destinationVC {
                destinationVC.vcDelegate = self
            }
        }
    }

}

extension TweetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if tweets.count > 0 {
            cell.tweet = tweets[indexPath.row]
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.lightGray
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.clear
    }
}

extension TweetViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isMoreDataLoading {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                loadData(paging: currentPage, isRefresh: false)
            }
        }
    }
}

extension TweetViewController: NewTweetViewControllerDelegate {
    func onNewTweetPosted(newTweet: Tweet) {
        tweets.insert(newTweet, at: 0)
        tableView.reloadData()
    }
}
