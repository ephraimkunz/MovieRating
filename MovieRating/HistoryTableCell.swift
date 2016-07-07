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
    
    func setData(data: BarcodeData){
        title.text = data.title
        barcode.text = data.barcode
        date.text = getDateText(data.timestamp!)
        
        if let imdb = data.imdbRating, rotten = data.rottenRating, meta = data.metaRating{
            
            //Take average
            rating.text = formatRatingsText(
                NSNumber.init(double:
                    (imdb.doubleValue + meta.doubleValue + rotten.doubleValue) / 3
                ))
            rating.hidden = false
            ratingIcon.hidden = false
            ratingIconHeight.constant = 25
        }
        else{
            rating.hidden = true
            ratingIcon.hidden = true
            ratingIconHeight.constant = 0 //Don't leave space in the cell for it if we won't show it
        }
    }
    
    func formatRatingsText(ratingNumber: NSNumber) -> String{
        let doubleVal = ratingNumber.doubleValue
        rating.textColor = Platform.getColorForRating(doubleVal)
        
        let formatter = NSNumberFormatter()
        formatter.positiveFormat = "0.#"
        return formatter.stringFromNumber(ratingNumber)!
    }
    
    func getDateText(millis: NSNumber) -> String{
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(millis.doubleValue))
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        return formatter.stringFromDate(date)
    }
}
