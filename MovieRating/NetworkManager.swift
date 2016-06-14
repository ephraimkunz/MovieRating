//
//  NetworkManager.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 6/12/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation
class NetworkManager{
    class func getItemForUPC(code: String, callback: (data: String) -> Void){
        let url = NSURL(string: "http://www.searchupc.com/handlers/upcsearch.ashx?request_type=3&access_token=5A19B55C-88CB-4F31-937B-8FF6380C62D3&upc=\(code)")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            do{
                let str = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                
                let item = str["0"]! as! [String:String]
                print(item)
                let productName = item["productname"]!
                dispatch_async(dispatch_get_main_queue()){
                    callback(data: productName)
                }
            }
            catch {
                print("json error: \(error)")
            }
        })
        task.resume()
    }
    
    class func getRatingForItemTitle(title: String, callback: (data: NSDictionary) -> Void){
        let encodedTitle = title.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        let url = NSURL(string: "http://www.omdbapi.com/?t=\(encodedTitle))&y=&plot=short&r=json&tomatoes=true")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            do{
                let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
               // print( try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! String)
                
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
}