//
//  DetailViewController.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 6/12/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation
import UIKit
import Cosmos
import ChameleonFramework
import Crashlytics

let titleSection = 0
let ratingSection = 1
let descriptionSection = 2

let descriptionCellId = "detailDescriptionCell"
let titleCellId = "detailTitleCell"
let ratingCellId = "detailRatingCell"

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var movieInfo = MovieInfo() // Need to set this property when we instantiate this view controller
    
    @IBOutlet weak var detailTableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(movieInfo.imdbRating != nil){
            if(movieInfo.description != nil && movieInfo.description != "N/A"){
                return 3
            }
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
            case descriptionSection:
                fallthrough
            case titleSection:
                return 1
            case ratingSection:
                return 3
            default:
                fatalError("numberOfRowsInSection called for unrecognized section: \(section)")
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ConfigurableCell
        switch (indexPath as NSIndexPath).section{
        case titleSection:
            cell = detailTableView.dequeueReusableCell(withIdentifier: titleCellId) as! DetailTitleCell
        case ratingSection:
            cell = detailTableView.dequeueReusableCell(withIdentifier: ratingCellId) as! DetailRatingCell
        case descriptionSection:
            cell = detailTableView.dequeueReusableCell(withIdentifier: descriptionCellId) as! DetailDescriptionCell
        default:
            fatalError("Unrecognized section for cellForRowAtIndexPath: \((indexPath as NSIndexPath).section)")
        }
        cell.configure((indexPath as NSIndexPath).row, data: self.movieInfo)
        return cell as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case titleSection:
            return "Information"
        case ratingSection:
            return "Ratings"
        case descriptionSection:
            return "Description"
        default:
            fatalError("Unrecognized section for titleForHeaderInSection: \(section)")
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200 //No special meaning to this, but to autosize the height we need it
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Only cells selectable are the rating cells with urls
        if (indexPath as NSIndexPath).section == ratingSection{
            let cell = tableView.cellForRow(at: indexPath) as! DetailRatingCell
            cell.didSelect(movieInfo)
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if (indexPath as NSIndexPath).section == descriptionSection || (indexPath as NSIndexPath).section == titleSection{
            return false
        }
        let cell = tableView.cellForRow(at: indexPath) as! DetailRatingCell
        return cell.shouldHighlightRow()
    }
    
    func deselectRow() {
        if let row = self.detailTableView.indexPathForSelectedRow{
            self.detailTableView.deselectRow(at: row, animated: true)
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.deselectRow), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        detailTableView.rowHeight = UITableViewAutomaticDimension
        let parent = self.navigationController!.viewControllers.first! //Find this out here and save it so that we avoid the race condition where they press back before the url request completes.
        
        
        //Save the barcode basic info here. Sometimes the omdb lookup seems to timeout so no history is saved. By saving here, we can update it if the omdb api works.
         BarcodeStore().saveBarcode(self.movieInfo, saveTimestamp: parent.isKind(of: ViewController.self))
        
        /* So why do we do this here. I'm glad you asked. A couple reasons. First, we want to switch from
         the barcode scanning screen as quickly as possible after a scan happens so the user knows that it
         worked. We want to give them any information we have as soon as we have it. Secondly, this method
         will also run when the view is launched by the history tableView. Thus, we always get the latest
         ratings and update the history with them.
         */
        if let movieTitle = movieInfo.title{
            // Log for analytics
            let contentType = parent.isKind(of: ViewController.self) ? "New scan" : "History"
            Answers.logContentView(withName: "Viewing Detail Page For Barcode",
                                           contentType: contentType,
                                           contentId: movieInfo.barcode!,
                                           customAttributes: [
                                            "title": movieInfo.title!
                ])
    
            NetworkManager.getRatingForItemTitle(movieTitle){ json in
                if let imdb = json["imdbRating"] as? NSString{
                    let imdbDouble = imdb.doubleValue
                    self.movieInfo.imdbRating = imdbDouble
                }
                
                if let meta = json["Metascore"] as? NSString{
                    let metaDouble = meta.doubleValue / 10.0
                    self.movieInfo.metaRating = metaDouble
                }
                
                if let tomato = json["tomatoRating"] as? NSString{
                    let tomatoDouble = tomato.doubleValue
                    self.movieInfo.rottenRating = tomatoDouble
                }
                
                if let tomatoConsensus = json["tomatoConsensus"] as? String{
                    self.movieInfo.description = tomatoConsensus
                }
                
//                if let imageUrl = json["Poster"] as? String{
//                    self.movieInfo.imageUrl = imageUrl
//                }
                
                if let mpaa = json["Rated"] as? String{
                    self.movieInfo.mpaaRating = mpaa
                }
                
                if let year = json["Year"] as? String{
                    self.movieInfo.year = year
                }
                
                if let imdbId = json["imdbID"] as? String{
                    self.movieInfo.imdbId = imdbId
                }
                
                if let rottenUrl = json["tomatoURL"] as? String{
                    self.movieInfo.rottenUrl = rottenUrl
                }
                
                BarcodeStore().saveBarcode(self.movieInfo, saveTimestamp: parent.isKind(of: ViewController.self))
                
                if let rating = self.movieInfo.imdbRating{
                    self.navigationController?.navigationBar.barTintColor = Platform.getColorForRating(rating)
                }
                self.detailTableView.reloadData() //Now that we have all the raings, make sure we show them
            }
        }
    }
}
