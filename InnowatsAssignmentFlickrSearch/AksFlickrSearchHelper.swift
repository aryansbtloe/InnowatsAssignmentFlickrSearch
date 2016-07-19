//
//  AksFlickrSearchHelper.swift
//  InnowatsAssignmentFlickrSearch
//
//  Created by Innowats on 20/07/16.
//  Copyright © 2016 Alok Kumar Singh. All rights reserved.
//

import Foundation
import AFNetworking

typealias AksFlickrSearchHelperCompletionBlock = (returnedData :AnyObject?) ->()

class AksFlickrSearchHelper: NSObject{
    var completionBlock: AksFlickrSearchHelperCompletionBlock?
    class var sharedInstance: AksFlickrSearchHelper {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: AksFlickrSearchHelper? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = AksFlickrSearchHelper()
        }
        return Static.instance!
    }
    
    private override init() {
        
    }
    
    func searchFlickrForImagesWithTag(tag:String,completion:AksFlickrSearchHelperCompletionBlock) {
        let url :String = "https://api.flickr.com/services/rest/"
        let parameters :Dictionary = [
            "method"         : "flickr.photos.search",
            "api_key"        : "86997f23273f5a518b027e2c8c019b0f",
            "per_page"       : "99",
            "format"         : "json",
            "nojsoncallback" : "1",
            "extras"         : "url_q,url_z",
            "tags"           : tag
        ]
        let manager = AFHTTPSessionManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.GET(url, parameters: parameters, progress: { (progress) -> Void in
            
            }, success: { (urlSessionDataTask, responseObject) -> Void in
                let responseDictionary = self.parsedJsonFrom(responseObject as? NSData ,methodName: #function)
                if let rootObject = responseDictionary as? NSDictionary{
                    if let photos = responseDictionary?.objectForKey("photos") as? NSDictionary{
                        if let photosArray = photos.objectForKey("photo") as? NSArray{
                            completion(returnedData: photosArray); return
                        }
                    }
                }
                completion(returnedData: nil)
        }){(urlSessionDataTask, error) -> Void in
            completion(returnedData: error)
        }
    }
    
    
    func parsedJsonFrom (data : NSData?,methodName: NSString) -> (AnyObject?) {
        let parsedData : AnyObject?
        do {
            parsedData =  try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
        } catch {
            parsedData = nil;
        }
        return parsedData;
    }
}