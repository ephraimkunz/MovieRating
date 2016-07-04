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
    @NSManaged var title: String?
    @NSManaged var rottenRating: NSNumber?
    @NSManaged var imdbRating: NSNumber?
    @NSManaged var metaRating: NSNumber?
    @NSManaged var timestamp: NSNumber?
    @NSManaged var descriptionText: String?
    @NSManaged var imageUrl: String?
    @NSManaged var year: String?
    @NSManaged var mpaaRating: String?
    @NSManaged var imdbId: String?
    @NSManaged var rottenUrl: String?
    
    func toMovieInfo() -> MovieInfo{
        let imdbDouble = imdbRating?.doubleValue
        let rottenDouble = rottenRating?.doubleValue
        let metaDouble = metaRating?.doubleValue

        //FIXME: Fix this ugly stopgap measure
        let movieInfo = MovieInfo(title: title, imdbRating: imdbDouble, metaRating: metaDouble, rottenRating: rottenDouble, barcode: barcode, imageUrl: imageUrl, description: descriptionText, year: year, mpaaRating: mpaaRating, imdbId: imdbId, rottenUrl: rottenUrl)
        
        return movieInfo
    }
}
