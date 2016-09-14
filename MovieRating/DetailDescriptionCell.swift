//
//  DetailDescriptionCell.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 7/4/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation
import UIKit

class DetailDescriptionCell: UITableViewCell, ConfigurableCell{
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure(_ row: Int, data: MovieInfo){
        if let descriptionText = data.description{
            descriptionLabel.text = descriptionText
        }
    }
}
