//
//  LoginViewController.swift
//  Twitters
//
//  Created by Nguyen Quang Ngoc Tan on 3/1/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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

    
    @IBAction func loginBtnClick(_ sender: UIButton) {
        // to make sure whoever login before, loutout first
        TwitterClient.instance?.deauthorize()
        
        TwitterClient.instance?.fetchRequestToken(withPath: "oauth/request_token", method: "POST", callbackURL: URL(string: "nqntantwitter://"), scope: nil, success: { (response: BDBOAuth1Credential?) in
            
            if let response = response {
                print(response.token)
                
                let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(response.token!)")
                
                UIApplication.shared.open(authURL!, options: [:], completionHandler: nil)
                
                
            }
            
        }, failure: { (error: Error?) in
            print("\(error?.localizedDescription)")
        })
    }

}
