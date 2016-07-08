//
//  HistoryViewController.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 6/22/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import UIKit
import ChameleonFramework

class HistoryViewController: UIViewController, UITableViewDelegate, TableViewHasDataProtocol{
    
    let barcodeStore = BarcodeStore()
    var dataSource: UITableViewDataSource?
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var trashButton: UIBarButtonItem!

    
    override func viewDidLoad() {
        dataSource = barcodeStore.tableViewDataSource(tableView: historyTableView, delegate: self)
        historyTableView.dataSource = dataSource
        historyTableView.delegate = self
        historyTableView.rowHeight = UITableViewAutomaticDimension
        historyTableView.estimatedRowHeight = 150
        historyTableView.separatorColor = UIColor.flatMintColor()
    }
    
    func tableViewHasData(data: Bool) {
        trashButton.enabled = data

        if (data){
            self.historyTableView.separatorStyle = .SingleLine;
            self.historyTableView.backgroundView = nil;
        }
        else{
            let noDataLabel = UINib(nibName: "NoDataLabel", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
            self.historyTableView.backgroundView = noDataLabel;
            self.historyTableView.separatorStyle = .None;
        }
    }
    
    @IBAction func cameraButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func trashButtonTapped(sender: AnyObject) {
        let alert = UIAlertController(title: "Delete History", message: "Are you sure you want to delete your scan history?", preferredStyle: .Alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive){
            (action: UIAlertAction!) -> Void in
            self.barcodeStore.removeHistory()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! HistoryTableCell
        let detailView = self.storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as! DetailViewController
        detailView.movieInfo = barcodeStore.getHistoryByBarcode(cell.barcode!.text!)!.toMovieInfo()
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        if let row = self.historyTableView.indexPathForSelectedRow{
            self.historyTableView.deselectRowAtIndexPath(row, animated: animated)
        }
        self.navigationController?.navigationBar.barTintColor = UIColor.flatMintColor()
    }
}

