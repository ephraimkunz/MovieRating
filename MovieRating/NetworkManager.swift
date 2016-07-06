//
//  NetworkManager.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 6/12/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation
import UIKit
class NetworkManager{
    class func getItemForUPC(code: String, callback: (data: MovieInfo) -> Void){
        let url = NSURL(string: "http://www.searchupc.com/handlers/upcsearch.ashx?request_type=3&access_token=5A19B55C-88CB-4F31-937B-8FF6380C62D3&upc=\(code)")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            do{
                let str = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                
                let item = str["0"]! as! [String:String]
                print(item)
                let movieInfo = MovieInfo()
                movieInfo.title = NetworkManager.parseRawTitle(item["productname"])
                movieInfo.imageUrl = item["imageurl"]
                
                movieInfo.barcode = code
                dispatch_async(dispatch_get_main_queue()){
                    callback(data: movieInfo)
                }
            }
            catch {
                print("json error: \(error)")
            }
        })
        task.resume()
    }

//    class func getItemForUPC(code: String, callback: (data: MovieInfo) -> Void){
//        let url = NSURL(string: "http://api.upcdatabase.org/json/82a4b5ee8dbaf3d18a653a0a74aeff66/\(code)")
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
//            do{
//                let str = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
//                
//                let item = str as! [String: AnyObject]
//                print(item)
//                let movieInfo = MovieInfo()
//                movieInfo.title = NetworkManager.parseRawTitle(item["itemname"] as? String)
//                //movieInfo.imageUrl = item["imageurl"]
//                
//                movieInfo.barcode = code
//                dispatch_async(dispatch_get_main_queue()){
//                    callback(data: movieInfo)
//                }
//            }
//            catch {
//                print("json error: \(error)")
//            }
//        })
//        task.resume()
//    }

    
    class func parseRawTitle(raw: String?) -> String?{
        //Remove items in brackets or parenthesis, along with brackets or parenthesis
        guard let rawUnwrapped = raw else{
            return raw
        }
        var parsed = rawUnwrapped.stringByReplacingOccurrencesOfString("\\(.*\\)", withString: "", options: .RegularExpressionSearch, range: rawUnwrapped.startIndex ..< rawUnwrapped.endIndex)
        
        parsed = parsed.stringByReplacingOccurrencesOfString("\\[.*\\]", withString: "", options: .RegularExpressionSearch, range: parsed.startIndex ..< parsed.endIndex)
        
        return parsed
    }
    
    class func getRatingForItemTitle(title: String, callback: (data: NSDictionary) -> Void){
        let encodedTitle = title.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        let url = NSURL(string: "http://www.omdbapi.com/?t=\(encodedTitle))&y=&plot=short&r=json&tomatoes=true")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            do{
                let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                
                print("Ratings fetch \(dict.description)")
                dispatch_async(dispatch_get_main_queue()){
                    callback(data: dict)
                }
            }
            catch {
                print("json error: \(error)")
            }
        })
        task.resume()
    }
    
    class func getImageForUrl(imageUrl: String, callback: (image: UIImage) -> Void){
        let url = NSURL(string: imageUrl)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                if let data = data, image = UIImage(data: data){
                    dispatch_async(dispatch_get_main_queue()){
                        callback(image: image)
                    }
                }
        })
        task.resume()

    }
}