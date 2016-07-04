//
//  DetailRatingCell.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 7/4/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation
import UIKit
import Cosmos

let imdbRow = 0
let rottenRow = 1
let metaRow = 2

let imdbUrlScheme = "imdb:///title/"

class DetailRatingCell: UITableViewCell, ConfigurableCell{
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var ratingStars: CosmosView!
    @IBOutlet weak var ratingValue: UILabel!
    var type = RatingType.NoType
    
    func configure(row: Int, data: MovieInfo){
        switch row{
        case imdbRow:
            type = RatingType.Imdb
            iconImage.image = UIImage(named: "imdbIcon")
            if let rating = data.imdbRating{
                ratingStars.rating = rating
                ratingValue.text = String(rating)
            }
            self.accessoryType = .DisclosureIndicator
        case rottenRow:
            type = RatingType.Rotten
            iconImage.image = UIImage(named: "rottenIcon")
            if let rating = data.rottenRating{
                ratingStars.rating = rating
                ratingValue.text = String(rating)
            }
            self.accessoryType = .DisclosureIndicator
        case metaRow:
            type = RatingType.Meta
            iconImage.image = UIImage(named: "metaIcon")
            if let rating = data.metaRating{
                ratingStars.rating = rating
                ratingValue.text = String(rating)
            }
            self.accessoryType = .None
        default:
            fatalError("Unexpected row to fetch icon image for: \(row)")
        }
    }
    
    func shouldHighlightRow() -> Bool{
        return type != RatingType.Meta
    }
    
    func didSelect(data: MovieInfo){
        let url: NSURL
        switch type {
        case .Imdb:
            url = NSURL(string: imdbUrlScheme + data.imdbId!)!
        case .Rotten:
            url = NSURL(string: data.rottenUrl!)!
        default:
            fatalError("User selected row that should never have been selected")
        }
        
        UIApplication.sharedApplication().openURL(url)
    }
}