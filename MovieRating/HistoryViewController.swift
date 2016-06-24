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
        historyTableView.reloadData()
    }
    
    @IBAction func cameraButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

