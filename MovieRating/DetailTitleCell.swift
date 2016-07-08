//
//  DetailTitleCell.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 7/4/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation
import UIKit

class DetailTitleCell: UITableViewCell, ConfigurableCell{
    
    @IBOutlet weak var infoImage: UIImageView!
    @IBOutlet weak var infoTitle: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var mpaaRatingLabel: UILabel!
    
    func configure(row: Int, data: MovieInfo){
        if let imageUrl = data.imageUrl{
            NetworkManager.getImageForUrl(imageUrl){ image in
                self.infoImage.image = image
            }
        } else{
          //  self.infoImage.image = UIImage(named: "imagePlaceholder")
        }
        if let title = data.title{
            infoTitle.text = title
        }
        
        if let year = data.year{
            yearLabel.hidden = false
            yearLabel.text = year + " • "
        }else{
            yearLabel.hidden = true
        }
        
        if let mpaaRating = data.mpaaRating{
            mpaaRatingLabel.hidden = false
            mpaaRatingLabel.text = mpaaRating
        }else{
            mpaaRatingLabel.hidden = true
        }
    }
}
