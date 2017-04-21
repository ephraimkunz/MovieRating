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
    var type = RatingType.noType
    
    func configure(_ row: Int, data: MovieInfo){
        switch row{
        case imdbRow:
            type = RatingType.imdb
            iconImage.image = UIImage(named: "imdbIcon")
            if let rating = data.imdbRating{
                ratingStars.rating = rating
                ratingValue.text = String(rating)
            }
            if data.imdbId != nil{
                self.accessoryType = .disclosureIndicator
            }else{
                self.accessoryType = .none
            }
        case rottenRow:
            type = RatingType.rotten
            iconImage.image = UIImage(named: "rottenIcon")
            if let rating = data.rottenRating{
                ratingStars.rating = rating
                ratingValue.text = String(rating)
            }
            if data.rottenUrl != nil{
                self.accessoryType = .disclosureIndicator
            }else{
                self.accessoryType = .none
            }

            case metaRow:
            type = RatingType.meta
            iconImage.image = UIImage(named: "metaIcon")
            if let rating = data.metaRating{
                ratingStars.rating = rating
                ratingValue.text = String(rating)
            }
            self.accessoryType = .none
        default:
            fatalError("Unexpected row to fetch icon image for: \(row)")
        }
    }
    
    func shouldHighlightRow() -> Bool{
        return self.accessoryType != .none
    }
    
    func didSelect(_ data: MovieInfo){
        let url: URL
        switch type {
        case .imdb:
            if let id = data.imdbId{
                url = URL(string: imdbUrlScheme + id)!
                UIApplication.shared.openURL(url)

            }
        case .rotten:
            if let rottenUrl = data.rottenUrl{
                url = URL(string: rottenUrl)!
                UIApplication.shared.openURL(url)
            }
        default:
            fatalError("User selected row that should never have been selected")
        }
    }
}
