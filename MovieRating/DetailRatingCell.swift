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
            if data.imdbId != nil{
                self.accessoryType = .DisclosureIndicator
            }else{
                self.accessoryType = .None
            }
        case rottenRow:
            type = RatingType.Rotten
            iconImage.image = UIImage(named: "rottenIcon")
            if let rating = data.rottenRating{
                ratingStars.rating = rating
                ratingValue.text = String(rating)
            }
            if data.rottenUrl != nil{
                self.accessoryType = .DisclosureIndicator
            }else{
                self.accessoryType = .None
            }

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
        return self.accessoryType != .None
    }
    
    func didSelect(data: MovieInfo){
        let url: NSURL
        switch type {
        case .Imdb:
            if let id = data.imdbId{
                url = NSURL(string: imdbUrlScheme + id)!
                UIApplication.sharedApplication().openURL(url)

            }
        case .Rotten:
            if let rottenUrl = data.rottenUrl{
                url = NSURL(string: rottenUrl)!
                UIApplication.sharedApplication().openURL(url)
            }
        default:
            fatalError("User selected row that should never have been selected")
        }
    }
}