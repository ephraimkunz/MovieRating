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

let titleSection = 0
let ratingSection = 1
let descriptionSection = 2

let descriptionCellId = "detailDescriptionCell"
let titleCellId = "detailTitleCell"
let ratingCellId = "detailRatingCell"

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var movieInfo = MovieInfo() // Need to set this property when we instantiate this view controller
    
    @IBOutlet weak var detailTableView: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: ConfigurableCell
        switch indexPath.section{
        case titleSection:
            cell = detailTableView.dequeueReusableCellWithIdentifier(titleCellId) as! DetailTitleCell
        case ratingSection:
            cell = detailTableView.dequeueReusableCellWithIdentifier(ratingCellId) as! DetailRatingCell
        case descriptionSection:
            cell = detailTableView.dequeueReusableCellWithIdentifier(descriptionCellId) as! DetailDescriptionCell
        default:
            fatalError("Unrecognized section for cellForRowAtIndexPath: \(indexPath.section)")
        }
        cell.configure(indexPath.row, data: self.movieInfo)
        return cell as! UITableViewCell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200 //No special meaning to this, but to autosize the height we need it
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Only cells selectable are the rating cells with urls
        if indexPath.section == ratingSection{
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! DetailRatingCell
            cell.didSelect(movieInfo)
        }
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == descriptionSection || indexPath.section == titleSection{
            return false
        }
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! DetailRatingCell
        return cell.shouldHighlightRow()
    }
    
    func deselectRow() {
        if let row = self.detailTableView.indexPathForSelectedRow{
            self.detailTableView.deselectRowAtIndexPath(row, animated: true)
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DetailViewController.deselectRow), name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        detailTableView.rowHeight = UITableViewAutomaticDimension
        
        /* So why do we do this here. I'm glad you asked. A couple reasons. First, we want to switch from
         the barcode scanning screen as quickly as possible after a scan happens so the user knows that it
         worked. We want to give them any information we have as soon as we have it. Secondly, this method
         will also run when the view is launched by the history tableView. Thus, we always get the latest
         ratings and update the history with them.
         */
        if let movieTitle = movieInfo.title{
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
                                
                BarcodeStore().saveBarcode(self.movieInfo)
                
                if self.movieInfo.imdbRating < 6.0{
                    self.navigationController?.navigationBar.barTintColor = UIColor.flatRedColor()
                }
                self.detailTableView.reloadData() //Now that we have all the raings, make sure we show them
            }
        }
    }
}