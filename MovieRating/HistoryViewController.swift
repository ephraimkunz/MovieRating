//
//  HistoryViewController.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 6/22/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    let barcodeStore = BarcodeStore()
    var dataSource: UITableViewDataSource?
    
    @IBOutlet weak var historyTableView: UITableView!
    override func viewDidLoad() {
        dataSource = barcodeStore.tableViewDataSource()
        historyTableView.dataSource = dataSource
        historyTableView.delegate = self
    }
    
    @IBAction func cameraButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let detailView = self.storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as! DetailViewController
        detailView.movieInfo = barcodeStore.getHistoryByBarcode(cell!.detailTextLabel!.text!)!.toMovieInfo()
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    override func viewDidAppear(animated: Bool){
        self.tableView.indexPathsForSelectedRows?.forEach{
            self.tableView.deselectRowAtIndexPath($0, animated: true)
        }
        
    }
}

