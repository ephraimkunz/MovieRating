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
        //Back up database to fetch item info from, if the current one stops working
        //"http://api.upcdatabase.org/json/82a4b5ee8dbaf3d18a653a0a74aeff66/\(code)"
        
        let url = URL(string: "http://www.searchupc.com/handlers/upcsearch.ashx?request_type=3&access_token=5A19B55C-88CB-4F31-937B-8FF6380C62D3&upc=\(code)")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, _, _) -> Void in
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
                let movieInfo = MovieInfo()
                
                if let dictionary = json as? [String:Any]{
                    if let item = dictionary["0"] as? [String:Any]{
                        print(item)
            
                        if let name = item["productname"] as? String{
                            movieInfo.title = NetworkManager.parseRawTitle(name)
                        }
                        
                        if let imageUrl = item["imageurl"] as? String{
                            movieInfo.imageUrl = imageUrl
                        }
                    }
                }
                
                movieInfo.barcode = code
                
                DispatchQueue.main.async{
                    callback(movieInfo)
                }
            }
            catch {
                print("Error parsing json: \(error)")
            }
        })
        task.resume()
    }
    
    class func parseRawTitle(_ raw: String?) -> String?{
        //Remove items in brackets or parenthesis, along with brackets or parenthesis
        guard let rawUnwrapped = raw else{
            return raw
        }
        
        var parsed = rawUnwrapped.replacingOccurrences(of: "\\(.*\\)", with: "", options: .regularExpression, range: rawUnwrapped.range(of: rawUnwrapped))
        
        parsed = parsed.replacingOccurrences(of: "\\[.*\\]", with: "", options: .regularExpression, range: parsed.range(of: parsed))
        
        return parsed
    }
    
    class func getRatingForItemTitle(_ title: String, callback: @escaping (_ data: Any) -> Void){
        var encodedTitle = title.trimmingCharacters(in: .whitespaces)
        encodedTitle = encodedTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        let url = URL(string: "https://www.omdbapi.com/?t=\(encodedTitle)&y=&plot=short&r=json&tomatoes=true")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
            do{
                guard error == nil else{
                    print("Error fetching ratings: \(error)")
                    return
                }
                let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
                
                print("Ratings fetch \(dict)")
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
