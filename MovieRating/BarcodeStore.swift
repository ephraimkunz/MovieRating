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
    
    private func historyFetchRequest() -> NSFetchRequest{
        return NSFetchRequest(entityName: BARCODE_NAME)
    }
    
    func tableViewDataSource(tableView refTableView: UITableView, delegate: TableViewHasDataProtocol?) -> UITableViewDataSource{
        return BarcodeStoreDatasource(tableView: refTableView, delegate: delegate);
    }
    
    func historyFetchedResultsController() -> NSFetchedResultsController{
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
            let fetchedHistory = try BarcodeStore.moc.executeFetchRequest(histFetch) as! [BarcodeData]
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
        
        //Check for if this is an update. If so, update the object, don't create a new one
        let entity: BarcodeData
        if let exists = getHistoryByBarcode(movieInfo.barcode!){
            entity = exists
        }
        else{
            entity = NSEntityDescription.insertNewObjectForEntityForName(BARCODE_NAME, inManagedObjectContext: BarcodeStore.moc) as! BarcodeData
        }
        
        entity.title = movieInfo.title
        entity.detail = movieInfo.detail
        entity.imdbRating = movieInfo.imdbRating
        entity.metaRating = movieInfo.metaRating
        entity.rottenRating = movieInfo.rottenRating
        entity.timestamp = NSDate().timeIntervalSince1970
        entity.barcode = movieInfo.barcode
        
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
            let results = try BarcodeStore.moc.executeFetchRequest(fetchRequest)
            for managedObject in results{
                BarcodeStore.moc.deleteObject(managedObject as! NSManagedObject)
            }
            try BarcodeStore.moc.save()
        }
        catch{
            fatalError("Error removing all history from Core Data")
        }
    }
    
    func getHistoryByBarcode(barcode: String) -> BarcodeData?{
        let fetchRequest = historyFetchRequest()
        let predicate = NSPredicate(format: "barcode = %@", barcode)
        fetchRequest.predicate = predicate
        
        do{
            let histItems = try BarcodeStore.moc.executeFetchRequest(fetchRequest)
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
    
    func removeHistoryByBarcode(barcode: String){
        let fetchRequest = historyFetchRequest()
        let predicate = NSPredicate(format: "barcode = %@", barcode)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = predicate
        
        do{
            let results = try BarcodeStore.moc.executeFetchRequest(fetchRequest)
            BarcodeStore.moc.deleteObject(results.first as! NSManagedObject)
            try BarcodeStore.moc.save()
        }
        catch{
            fatalError("Error removing all history from Core Data")
        }

    }
}