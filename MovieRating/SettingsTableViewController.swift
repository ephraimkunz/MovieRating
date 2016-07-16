//
//  SettingsTableViewController.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 7/6/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate{
    @IBAction func doneButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        let footerView = UINib(nibName: "SettingsViewFooter", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
        footerView.frame = CGRectMake(0, 0, 50, 100)
        self.tableView.tableFooterView = footerView
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("leaveFeedbackCell") as! LeaveFeedbackCell
        cell.parentTableView = self
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func launchMailComposer(){
        if(MFMailComposeViewController.canSendMail()){
            let body = "\n\n\niOS: \(Platform.systemName()) \(Platform.systemVersion())\nApp: \(Platform.appName())\nVersion: \(Platform.appVersion())\nBuild: \(Platform.appBuild())"
            
            let controller = MFMailComposeViewController()
            controller.mailComposeDelegate = self
            controller.setToRecipients(["ephraimkunz@me.com"])
            controller.setSubject("Feedback for MovieRating")
            controller.setMessageBody(body, isHTML: false)
            self.presentViewController(controller, animated: true, completion: nil)
        }
        else{
            let alertController = UIAlertController( title:"Error sending feedback", message:"Mail must be set up on this device to send feedback", preferredStyle: .Alert)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}