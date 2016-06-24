//
//  BarcodeData.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 6/22/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation
import CoreData

class BarcodeData: NSManagedObject{
    @NSManaged var barcode: String?
    @NSManaged var detail: String?
    @NSManaged var title: String?
    @NSManaged var rottenRating: NSNumber?
    @NSManaged var imdbRating: NSNumber?
    @NSManaged var metaRating: NSNumber?
    @NSManaged var timestamp: NSNumber?
    
    func toMovieInfo() -> MovieInfo{
        let imdbDouble = imdbRating?.doubleValue
        let rottenDouble = rottenRating?.doubleValue
        let metaDouble = metaRating?.doubleValue

        let movieInfo = MovieInfo(title: title, imdbRating: imdbDouble, metaRating: metaDouble, rottenRating: rottenDouble, detail: detail, barcode: barcode)
        
        return movieInfo
    }
}
