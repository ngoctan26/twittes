//
//  TwitterClient.swift
//  Twitters
//
//  Created by Nguyen Quang Ngoc Tan on 3/1/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

let baseUrl = URL(string: "https://api.twitter.com/")
let consumerKey = "No8YvX0Lyo4TjUSKvSI4z6Isz"
let consumerSecret = "e5t9AyLKm3Tn5QshlPlK4MyF9Yk5RIo6O6dSsKe6eEihXxKtcD"

class TwitterClient: BDBOAuth1SessionManager {
    let RESULT_LIMIT = 20
    static var instance = TwitterClient(baseURL: baseUrl, consumerKey: consumerKey, consumerSecret: consumerSecret)
    
    var user: User!
    
    func getUserInfo(completion: @escaping  (_ error: Error?, _ userInfo: User?) -> ()) {
        _ = get("1.1/account/verify_credentials.json", parameters: nil, success: { (_: URLSessionDataTask, response: Any?) in
            if let response = response  {
                self.user = User(dictionary: response as! NSDictionary)
                completion(nil, self.user)
            }
            
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            print("\(error.localizedDescription)")
            completion(error, nil)
        })
    }
    
    func homeTimeline(paging: String?, completion: @escaping  (_ error: Error?, _ tweetList: [Tweet]?) -> ()) {
        var parameters: [String : Any] = [:]
        parameters["count"] = RESULT_LIMIT
        if let paging = paging {
            let sinceId = paging
            parameters["max_id"] = sinceId
        }
        _ = get("1.1/statuses/home_timeline.json", parameters: parameters, success: { (_: URLSessionDataTask, response: Any?) in
            if let response = response  {
                var returnTweets = [Tweet]()
                let tweets = response as! [NSDictionary]
                for t in tweets {
                    let tweet = Tweet(dictionary: t)
                    returnTweets.append(tweet)
                }
                completion(nil, returnTweets)
            }
            
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            print("\(error.localizedDescription)")
            completion(error, nil)
        })
    }
    
    func sendTweet(text: String, failure: @escaping (_ error: Error?) -> (), success: @escaping (_ success: Tweet) -> ()) {
        var parameters: [String : Any] = [:]
        parameters["status"] = text
        _ = post("1.1/statuses/update.json", parameters: parameters,  success: { (_: URLSessionDataTask, response: Any?) in
            if let response = response  {
                print("new tweet response: \(response)")
                let tweetRaw = response as! NSDictionary
                let tweet = Tweet(dictionary: tweetRaw)
                success(tweet)
            }
            
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            print("\(error.localizedDescription)")
            failure(error)
        })
    }
    
    func createFavourite(id: String, failure: @escaping (_ error: Error?) -> (), success: @escaping (_ success: Tweet) -> ()) {
        var parameters: [String : Any] = [:]
        parameters["id"] = id
        _ = post("1.1/favorites/create.json", parameters: parameters, success: { (_: URLSessionDataTask, response: Any?) in
            if let response = response  {
                print("update favourite response: \(response)")
                let tweetRaw = response as! NSDictionary
                let tweet = Tweet(dictionary: tweetRaw)
                success(tweet)
            }
            
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            print("\(error.localizedDescription)")
            failure(error)
        })
    }
    
    func destroyFavourite(id: String, failure: @escaping (_ error: Error?) -> (), success: @escaping (_ success: Tweet) -> ()) {
        var parameters: [String : Any] = [:]
        parameters["id"] = id
        _ = post("1.1/favorites/destroy.json", parameters: parameters, success: { (_: URLSessionDataTask, response: Any?) in
            if let response = response  {
                print("update favourite response: \(response)")
                let tweetRaw = response as! NSDictionary
                let tweet = Tweet(dictionary: tweetRaw)
                success(tweet)
            }
            
        }, failure: { (_: URLSessionDataTask?, error: Error) in
            print("\(error.localizedDescription)")
            failure(error)
        })
    }
}
