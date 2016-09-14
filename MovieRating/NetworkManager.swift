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
    class func getItemForUPC(_ code: String, callback: @escaping (_ data: MovieInfo) -> Void){
        let url = URL(string: "http://www.searchupc.com/handlers/upcsearch.ashx?request_type=3&access_token=5A19B55C-88CB-4F31-937B-8FF6380C62D3&upc=\(code)")
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
            do{
                let str = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
                
                let item = (str as AnyObject)["0"]! as! [String:String]
                print(item)
                let movieInfo = MovieInfo()
                movieInfo.title = NetworkManager.parseRawTitle(item["productname"])
                movieInfo.imageUrl = item["imageurl"]
                
                movieInfo.barcode = code
                DispatchQueue.main.async{
                    callback(movieInfo)
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

    
    class func parseRawTitle(_ raw: String?) -> String?{
        //Remove items in brackets or parenthesis, along with brackets or parenthesis
        guard let rawUnwrapped = raw else{
            return raw
        }
        
        var parsed = rawUnwrapped.replacingOccurrences(of: "\\(.*\\)", with: "", options: .regularExpression, range: rawUnwrapped.range(of: rawUnwrapped))
        
        parsed = parsed.replacingOccurrences(of: "\\[.*\\]", with: "", options: .regularExpression, range: parsed.range(of: parsed))
        
        return parsed
    }
    
    class func getRatingForItemTitle(_ title: String, callback: @escaping (_ data: NSDictionary) -> Void){
        var encodedTitle = title.trimmingCharacters(in: .whitespaces)
        encodedTitle = encodedTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!


        let url = URL(string: "https://www.omdbapi.com/?t=\(encodedTitle)&y=&plot=short&r=json&tomatoes=true")
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
            do{
                guard error == nil else{
                    print("Error fetching ratings: \(error)")
                    return
                }
                let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                
                print("Ratings fetch \(dict.description)")
                DispatchQueue.main.async{
                    callback(dict)
                }
            }
            catch {
                print("json error: \(error)")
            }
        })
        task.resume()
    }
    
    class func getImageForUrl(_ imageUrl: String, callback: @escaping (_ image: UIImage) -> Void){
        let url = URL(string: imageUrl)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
                if let data = data, let image = UIImage(data: data){
                    DispatchQueue.main.async{
                        callback(image)
                    }
                }
        })
        task.resume()

    }
}
