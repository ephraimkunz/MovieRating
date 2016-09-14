//
//  BarcodeStore.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 6/22/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import UIKit
import CoreData
let BARCODE_NAME = "BarcodeData"

class BarcodeStore{
    static let moc = CoreDataController().managedObjectContext //Singleton so that we all use it. This way,
    //FetchedResultController can keep track of the changes
    
    fileprivate func historyFetchRequest() -> NSFetchRequest<AnyObject>{
        return NSFetchRequest(entityName: BARCODE_NAME)
    }
    
    func tableViewDataSource(tableView refTableView: UITableView, delegate: TableViewHasDataProtocol?) -> UITableViewDataSource{
        return BarcodeStoreDatasource(tableView: refTableView, delegate: delegate);
    }
    
    func historyFetchedResultsController() -> NSFetchedResultsController<AnyObject>{
        let request = historyFetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]

        let fetched = NSFetchedResultsController(fetchRequest: request, managedObjectContext: BarcodeStore.moc, sectionNameKeyPath: nil, cacheName: nil)
        do{
            try fetched.performFetch()
        }
        catch{
            fatalError("Failed to execute fetch in FetchedResultsController")
        }
        return fetched
    }
    
    func getHistory() -> [BarcodeData]{
        
        let histFetch = historyFetchRequest()
        let sort = NSSortDescriptor(key: "timestamp", ascending: false)
        histFetch.sortDescriptors = [sort]
        
        do{
            let fetchedHistory = try BarcodeStore.moc.fetch(histFetch) as! [BarcodeData]
            return fetchedHistory
        }
        catch{
            fatalError("Error fetching history from CoreData")
        }
    }
    
    
    func saveBarcode(_ movieInfo: MovieInfo, saveTimestamp: Bool){
        if movieInfo.title == nil || movieInfo.title! == " " {
            return //Don't save with no title: this means there is no other useful info. But we still need to allow the user to get to the detail screen so they know that.
        }
        
        //Check for if this is an update. If so, update the object, don't create a new one
        let entity: BarcodeData
        if let exists = getHistoryByBarcode(movieInfo.barcode!){
            entity = exists
        }
        else{
            entity = NSEntityDescription.insertNewObject(forEntityName: BARCODE_NAME, into: BarcodeStore.moc) as! BarcodeData
        }
        
        if(saveTimestamp){
            entity.timestamp = Date().timeIntervalSince1970 as NSNumber?
        }
        entity.title = movieInfo.title
        entity.imdbRating = movieInfo.imdbRating as NSNumber?
        entity.metaRating = movieInfo.metaRating as NSNumber?
        entity.rottenRating = movieInfo.rottenRating as NSNumber?
        entity.barcode = movieInfo.barcode
        entity.imdbId = movieInfo.imdbId
        entity.rottenUrl = movieInfo.rottenUrl
        entity.descriptionText = movieInfo.description
        entity.year = movieInfo.year
        entity.mpaaRating = movieInfo.mpaaRating
        entity.imageUrl = movieInfo.imageUrl
        
        do{
            try BarcodeStore.moc.save()
        }
        catch {
            fatalError("Error saving barcode to Core Data")
        }
        
    }
    
    func removeHistory(){
        let fetchRequest = historyFetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        do{
            let results = try BarcodeStore.moc.fetch(fetchRequest)
            for managedObject in results{
                BarcodeStore.moc.delete(managedObject as! NSManagedObject)
            }
            try BarcodeStore.moc.save()
        }
        catch{
            fatalError("Error removing all history from Core Data")
        }
    }
    
    func getHistoryByBarcode(_ barcode: String) -> BarcodeData?{
        let fetchRequest = historyFetchRequest()
        let predicate = NSPredicate(format: "barcode = %@", barcode)
        fetchRequest.predicate = predicate
        
        do{
            let histItems = try BarcodeStore.moc.fetch(fetchRequest)
            let items = histItems as! [BarcodeData]
            if let item = items.first{
                return item
            }
            else {
                return nil
            }
        }
        catch{
            fatalError("Error fetching item with barcode \(barcode) from Core Data")
        }
    }
    
    func removeHistoryByBarcode(_ barcode: String){
        let fetchRequest = historyFetchRequest()
        let predicate = NSPredicate(format: "barcode = %@", barcode)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = predicate
        
        do{
            let results = try BarcodeStore.moc.fetch(fetchRequest)
            BarcodeStore.moc.delete(results.first as! NSManagedObject)
            try BarcodeStore.moc.save()
        }
        catch{
            fatalError("Error removing all history from Core Data")
        }

    }
}
