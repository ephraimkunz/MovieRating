//
//  PlatformUtils.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 6/22/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation
import UIKit

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
    
    static func getColorForRating(rating: Double) -> UIColor{
        if rating < NSUserDefaults().doubleForKey("badMovieThreshold"){
            return UIColor.flatRedColor()
        }
        else if rating < NSUserDefaults().doubleForKey("okMovieThreshold"){
            return UIColor.flatYellowColor()
        }
        else{
            return UIColor.flatGreenColor()
        }

    }
}
