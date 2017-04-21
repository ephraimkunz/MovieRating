//
//  HistoryTableCell.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 6/25/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation
import UIKit

class HistoryTableCell: UITableViewCell{
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var barcode: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var ratingIcon: UIImageView!
    @IBOutlet weak var ratingIconHeight: NSLayoutConstraint!
    
    func setData(_ data: BarcodeData){
        title.text = data.title
        barcode.text = data.barcode
        date.text = getDateText(data.timestamp!)
        
        if let imdb = data.imdbRating{
            rating.text = formatRatingsText(imdb)
            rating.isHidden = false
            ratingIcon.isHidden = false
            ratingIconHeight.constant = 25
        }
        else{
            rating.isHidden = true
            ratingIcon.isHidden = true
            ratingIconHeight.constant = 0 //Don't leave space in the cell for it if we won't show it
        }
    }
    
    func formatRatingsText(_ ratingNumber: NSNumber) -> String{
        let doubleVal = ratingNumber.doubleValue
        rating.textColor = Platform.getColorForRating(doubleVal)
        
        let formatter = NumberFormatter()
        formatter.positiveFormat = "0.#"
        return formatter.string(from: ratingNumber)!
    }
    
    func getDateText(_ millis: NSNumber) -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(millis.doubleValue))
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
