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

        let movieInfo = MovieInfo()
        movieInfo.title = title
        movieInfo.barcode = barcode
        movieInfo.rottenRating = rottenDouble
        movieInfo.imdbRating = imdbDouble
        movieInfo.metaRating = metaDouble
        movieInfo.description = descriptionText
        movieInfo.imageUrl = imageUrl
        movieInfo.year = year
        movieInfo.mpaaRating = mpaaRating
        movieInfo.imdbId = imdbId
        movieInfo.rottenUrl = rottenUrl
    
        return movieInfo
    }
}
