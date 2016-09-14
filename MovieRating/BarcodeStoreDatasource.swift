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
    var fetchedController: NSFetchedResultsController<AnyObject>
    var referencingTableView: UITableView
    var delegate: TableViewHasDataProtocol?
    
    init(tableView refTableView: UITableView, delegate: TableViewHasDataProtocol?){
        fetchedController = BarcodeStore().historyFetchedResultsController()
        referencingTableView = refTableView
        super.init()
        
        fetchedController.delegate = self
        self.delegate = delegate
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = fetchedController.object(at: indexPath) as! BarcodeData;
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! HistoryTableCell
        cell.setData(cellData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if fetchedController.sections![section].numberOfObjects > 0{
            self.delegate?.tableViewHasData(true)
        }
        else{
            self.delegate?.tableViewHasData(false)
        }
        
        return fetchedController.sections![section].numberOfObjects
    }
        
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .delete{
            referencingTableView.deleteRows(at: [indexPath!], with: .automatic)
        }
        else if type == .insert{
            referencingTableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
        else if type == .move{
            referencingTableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        referencingTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        referencingTableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let cellText = (tableView.cellForRow(at: indexPath) as! HistoryTableCell).barcode?.text
        BarcodeStore().removeHistoryByBarcode(cellText!)
    }
}
