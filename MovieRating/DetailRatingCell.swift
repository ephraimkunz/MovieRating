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

class DetailRatingCell: UITableViewCell, ConfigurableCell{
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var ratingStars: CosmosView!
    @IBOutlet weak var ratingValue: UILabel!
    
    func configure(row: Int, data: MovieInfo){
        switch row{
        case imdbRow:
            iconImage.image = UIImage(named: "imdbIcon")
            if let rating = data.imdbRating{
                ratingStars.rating = rating
                ratingValue.text = String(rating)
            }
        case rottenRow:
            iconImage.image = UIImage(named: "rottenIcon")
            if let rating = data.rottenRating{
                ratingStars.rating = rating
                ratingValue.text = String(rating)
            }
        case metaRow:
            iconImage.image = UIImage(named: "metaIcon")
            if let rating = data.metaRating{
                ratingStars.rating = rating
                ratingValue.text = String(rating)
            }
        default:
            fatalError("Unexpected row to fetch icon image for: \(row)")
        }
    }
}