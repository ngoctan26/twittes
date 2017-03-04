//
//  ImageUtil.swift
//  Yelp
//
//  Created by Nguyen Quang Ngoc Tan on 2/23/17.
//  Copyright © 2017 Nguyen Quang Ngoc Tan. All rights reserved.
//

import Foundation
import AFNetworking

class ImageUtils {
    
    static func loadImageFromUrlWithAnimate(imageView: UIImageView, url: URL?) {
        if let url = url {
            let imageRequest = NSURLRequest(url: url)
            imageView.setImageWith(imageRequest as URLRequest, placeholderImage: nil, success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    imageView.alpha = 0.0
                    imageView.image = image
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        imageView.alpha = 1.0
                    })
                } else {
                    print("Image was cached so just update the image")
                    imageView.image = image
                }
            },
                                   failure: { (imageRequest, imageResponse, error) -> Void in
                                    // do something for the failure condition
            })
        } else {
            // Image is not available
            
        }
    }
    
    static func loadImageFromLowToHighResolotion(imageView: UIImageView, highUrl: String, lowUrl: String) {
        let smallImageRequest = NSURLRequest(url: NSURL(string: lowUrl)! as URL)
        let largeImageRequest = NSURLRequest(url: NSURL(string: highUrl)! as URL)
        imageView.setImageWith(
            smallImageRequest as URLRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                
                // smallImageResponse will be nil if the smallImage is already available
                // in cache (might want to do something smarter in that case).
                imageView.alpha = 0.0
                imageView.image = smallImage;
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    
                    imageView.alpha = 1.0
                    
                }, completion: { (sucess) -> Void in
                    
                    // The AFNetworking ImageView Category only allows one request to be sent at a time
                    // per ImageView. This code must be in the completion block.
                    imageView.setImageWith(
                        largeImageRequest as URLRequest,
                        placeholderImage: smallImage,
                        success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            
                            imageView.image = largeImage;
                            
                    },
                        failure: { (request, response, error) -> Void in
                            // do something for the failure condition of the large image request
                            // possibly setting the ImageView's image to a default image
                    })
                })
        },
            failure: { (request, response, error) -> Void in
                // do something for the failure condition
                // possibly try to get the large image
        })
    }
}
