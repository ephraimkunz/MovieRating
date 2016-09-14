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
        historyTableView.separatorColor = UIColor.flatMint()
    }
    
    func tableViewHasData(_ data: Bool) {
        trashButton.isEnabled = data

        if (data){
            self.historyTableView.separatorStyle = .singleLine;
            self.historyTableView.backgroundView = nil;
        }
        else{
            let noDataLabel = UINib(nibName: "NoDataLabel", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
            
            self.historyTableView.backgroundView = noDataLabel;
            self.historyTableView.separatorStyle = .none;
        }
    }
    
    @IBAction func cameraButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func trashButtonTapped(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Delete History", message: "Are you sure you want to delete your scan history?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive){
            (action: UIAlertAction!) -> Void in
            self.barcodeStore.removeHistory()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! HistoryTableCell
        let detailView = self.storyboard?.instantiateViewController(withIdentifier: "detailViewController") as! DetailViewController
        detailView.movieInfo = barcodeStore.getHistoryByBarcode(cell.barcode!.text!)!.toMovieInfo()
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let row = self.historyTableView.indexPathForSelectedRow{
            self.historyTableView.deselectRow(at: row, animated: animated)
        }
        self.navigationController?.navigationBar.barTintColor = UIColor.flatMint()
    }
}

