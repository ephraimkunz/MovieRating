//
//  BarcodeStore.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 6/22/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import UIKit
import CoreData

class BarcodeStore{
    
    func tableViewDataSource() -> UITableViewDataSource{
        return BarcodeStoreDatasource();
    }
    
    func getHistory() -> [BarcodeData]{
        let moc = CoreDataController().managedObjectContext
        let histFetch = NSFetchRequest(entityName: "BarcodeData")
        let sort = NSSortDescriptor(key: "timestamp", ascending: false)
        histFetch.sortDescriptors = [sort]
        
        do{
            let fetchedHistory = try moc.executeFetchRequest(histFetch) as! [BarcodeData]
            return fetchedHistory
        }
        catch{
            fatalError("Error fetching history from CoreData")
        }
    }
    
    func saveBarcode(movieInfo: MovieInfo){
        let moc = CoreDataController().managedObjectContext
        let entity = NSEntityDescription.insertNewObjectForEntityForName("BarcodeData", inManagedObjectContext: moc) as! BarcodeData
        
        entity.title = movieInfo.title
        entity.detail = movieInfo.detail
        entity.imdbRating = movieInfo.imdbRating
        entity.metaRating = movieInfo.metaRating
        entity.rottenRating = movieInfo.rottenRating
        entity.timestamp = NSDate().timeIntervalSince1970
        
        do{
            try moc.save()
        }
        catch {
            fatalError("Error saving barcode to Core Data")
        }
        
    }
    
    func getHistoryByTimestamp(timestamp: Int64) -> BarcodeData{
        let moc = CoreDataController().managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "BarcodeData")
        let predicate = NSPredicate(format: "%K = %@", "timestamp", timestamp)
        fetchRequest.predicate = predicate
        
        do{
            if let histItem = (try moc.executeFetchRequest(fetchRequest) as! [BarcodeData]).first{
                return histItem
            }
            else{
                return BarcodeData()
            }
        }
        catch{
            fatalError("Error fetching item with timestamp \(timestamp) from Core Data")
        }
    }
}