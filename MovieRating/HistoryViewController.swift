//
//  HistoryViewController.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 6/22/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, TableViewHasDataProtocol{
    
    let barcodeStore = BarcodeStore()
    var dataSource: UITableViewDataSource?
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        dataSource = barcodeStore.tableViewDataSource(tableView: historyTableView, delegate: self)
        historyTableView.dataSource = dataSource
        historyTableView.delegate = self
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
        barcodeStore.removeHistory()
        historyTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let detailView = self.storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as! DetailViewController
        detailView.movieInfo = barcodeStore.getHistoryByBarcode(cell!.detailTextLabel!.text!)!.toMovieInfo()
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    override func viewDidAppear(animated: Bool){
        historyTableView.indexPathsForSelectedRows?.forEach{
            historyTableView.deselectRowAtIndexPath($0, animated: true)
        }
    }
}

