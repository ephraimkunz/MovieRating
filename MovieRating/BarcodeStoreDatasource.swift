//
//  BarcodeStoreDatasource.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 6/22/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import UIKit
import CoreData

class BarcodeStoreDatasource: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate{
    var fetchedController: NSFetchedResultsController
    var referencingTableView: UITableView
    var delegate: TableViewHasDataProtocol?
    
    init(tableView refTableView: UITableView, delegate: TableViewHasDataProtocol?){
        fetchedController = BarcodeStore().historyFetchedResultsController()
        referencingTableView = refTableView
        super.init()
        
        fetchedController.delegate = self
        self.delegate = delegate
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellData = fetchedController.objectAtIndexPath(indexPath) as! BarcodeData;
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell") as! HistoryTableCell
        cell.setData(cellData)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if fetchedController.sections![section].numberOfObjects > 0{
            self.delegate?.tableViewHasData(true)
        }
        else{
            self.delegate?.tableViewHasData(false)
        }
        
        return fetchedController.sections![section].numberOfObjects
    }
        
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if type == .Delete{
            referencingTableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        }
        else if type == .Insert{
            referencingTableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        }
        else if type == .Move{
            referencingTableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        referencingTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        referencingTableView.endUpdates()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let cellText = (tableView.cellForRowAtIndexPath(indexPath) as! HistoryTableCell).barcode?.text
        BarcodeStore().removeHistoryByBarcode(cellText!)
    }
}
