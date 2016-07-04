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
let ratingSection = 1;
let descriptionSection = 2;

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
        cell.configure(indexPath.row)
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
    
    
    override func viewDidLoad() {
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
                
                BarcodeStore().saveBarcode(self.movieInfo)
                
                if self.movieInfo.imdbRating < 6.0{
                    self.navigationController?.navigationBar.barTintColor = UIColor.flatRedColor()
                }
            }
        }
    }
}