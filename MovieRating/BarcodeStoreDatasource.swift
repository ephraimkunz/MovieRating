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
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellData = fetchedController.objectAtIndexPath(indexPath) as! BarcodeData;
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell")!
        cell.textLabel?.text = cellData.title
        cell.detailTextLabel?.text = cellData.barcode
        return cell
    }
    
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedController.sections{
            self.delegate?.tableViewHasData(true)
            return sections[section].numberOfObjects
        }
        else{
            self.delegate?.tableViewHasData(false)
            return 0
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if type == .Delete{
            referencingTableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        }
    }
    
}
