//
//  NewTweetViewController.swift
//  Twitters
//
//  Created by Nguyen Quang Ngoc Tan on 3/4/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit

@objc protocol NewTweetViewControllerDelegate {
    @objc optional func onNewTweetPosted(newTweet: Tweet)
}

class NewTweetViewController: UIViewController {
    //View references
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetTxField: UITextField!
    
    //Properties
    var user: User = (TwitterClient.instance?.user)!
    weak var vcDelegate: NewTweetViewControllerDelegate!
    
    //Actions
    @IBAction func tweetBtnClicked(_ sender: Any) {
        if (tweetTxField.text?.isEmpty)! {
            // show alert
            return
        }
        TwitterClient.instance?.sendTweet(text: tweetTxField.text!, failure: { (error) in
            // Handle when post error
        }, success: { (newTweet) in
            self.vcDelegate.onNewTweetPosted!(newTweet: newTweet)
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        tweetTxField.delegate = self
        ImageUtils.loadImageFromUrlWithAnimate(imageView: avatarImg, url: user.profileImageUrl)
        nameLabel.text = user.name
        screenNameLabel.text = "@\((user.screenName)!)"
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

extension NewTweetViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
        return newLength < 140
    }
}
