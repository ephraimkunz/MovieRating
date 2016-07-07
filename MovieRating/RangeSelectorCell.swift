//
//  RangeSelectorCell.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 7/6/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation
import TTRangeSlider
import UIKit

class RangeSelectorCell: UITableViewCell, TTRangeSliderDelegate{
    @IBOutlet weak var rangeSelector: TTRangeSlider!
    
    func configure(){
        rangeSelector.delegate = self
        rangeSelector.selectedMaximum = NSUserDefaults().floatForKey("okMovieThreshold")
        rangeSelector.selectedMinimum = NSUserDefaults().floatForKey("badMovieThreshold")
    }
    
    func rangeSlider(sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        NSUserDefaults().setValue(selectedMinimum, forKey: "badMovieThreshold")
        NSUserDefaults().setValue(selectedMaximum, forKey: "okMovieThreshold")
    }
}
