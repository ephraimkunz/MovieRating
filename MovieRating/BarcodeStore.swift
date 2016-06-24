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
        if movieInfo.title == nil || movieInfo.title! == " " {
            return //Don't save with no title: this means there is no other useful info
        }
        
         let moc = CoreDataController().managedObjectContext
        
        //Check for if this is an update. If so, update the object, don't create a new one
        let entity: BarcodeData
        if let exists = getHistoryByBarcode(movieInfo.barcode!){
            entity = exists
        }
        else{
            entity = NSEntityDescription.insertNewObjectForEntityForName("BarcodeData", inManagedObjectContext: moc) as! BarcodeData
        }
        
        entity.title = movieInfo.title
        entity.detail = movieInfo.detail
        entity.imdbRating = movieInfo.imdbRating
        entity.metaRating = movieInfo.metaRating
        entity.rottenRating = movieInfo.rottenRating
        entity.timestamp = NSDate().timeIntervalSince1970
        entity.barcode = movieInfo.barcode
        
        do{
            try moc.save()
        }
        catch {
            fatalError("Error saving barcode to Core Data")
        }
        
    }
    
    func getHistoryByBarcode(barcode: String) -> BarcodeData?{
        let moc = CoreDataController().managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "BarcodeData")
        let predicate = NSPredicate(format: "%K = %@", "barcode", barcode)
        fetchRequest.predicate = predicate
        
        do{
            if let histItem = (try moc.executeFetchRequest(fetchRequest) as! [BarcodeData]).first{
                return histItem
            }
            else{
                return nil
            }
        }
        catch{
            fatalError("Error fetching item with barcode \(barcode) from Core Data")
        }
    }
}