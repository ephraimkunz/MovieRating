//
//  SettingsTableViewController.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 7/6/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation
import UIKit
import TTRangeSlider

class SettingsTableViewController: UITableViewController{
    @IBAction func doneButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var rangeSlider: TTRangeSlider!
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("rangeSelectorCell") as! RangeSelectorCell
        cell.configure()
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UINib(nibName: "SettingsViewFooter", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
        return footerView
    }
}