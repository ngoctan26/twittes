//
//  AppDelegate.swift
//  Twitters
//
//  Created by Nguyen Quang Ngoc Tan on 3/1/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Check that If there is logged in user
        let token = SettingUtils.loadSetting(key: "save-token", defaultValue: nil)
        if ((token as? String) != nil) {
            TwitterClient.instance?.getUserInfo(completion: { (error, user) in
                if (user == nil) {
                    return
                } else {
                    self.moveToTweetVC()
                }
            })
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        TwitterClient.instance?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (response: BDBOAuth1Credential?) in
            if let response = response {
                print("access token = \(response.token)")
                SettingUtils.saveSetting(configurations: ["save-token" : response.token])
                TwitterClient.instance?.getUserInfo(completion: { (error, user) in
                    if (user == nil) {
                        return
                    } else {
                        self.moveToTweetVC()
                    }
                })
            }
        }, failure: { (error: Error?) in
            print("\(error?.localizedDescription)")
        })
        
        return true
    }

    func moveToTweetVC() {
        // Move to tweet vc
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tweetNavigationVC = storyboard.instantiateViewController(withIdentifier: "TweetController") as! UINavigationController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tweetNavigationVC
        self.window?.makeKeyAndVisible()
    }
}

