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
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaveFeedbackCell") as! LeaveFeedbackCell
        cell.parentTableView = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func launchMailComposer(){
        if(MFMailComposeViewController.canSendMail()){
            let body = "\n\n\niOS: \(Platform.systemName()) \(Platform.systemVersion())\nApp: \(Platform.appName())\nVersion: \(Platform.appVersion())\nBuild: \(Platform.appBuild())"
            
            UINavigationBar.appearance().barTintColor = UIColor.flatMint()

            let controller = MFMailComposeViewController()
            controller.navigationBar.tintColor = UIColor.white
            controller.mailComposeDelegate = self
            controller.setToRecipients(["ephraimkunz@me.com"])
            controller.setSubject("Feedback for MovieRating")
            controller.setMessageBody(body, isHTML: false)
            
            self.present(controller, animated: true, completion: nil)
        }
        else{
            let alertController = UIAlertController( title:"Error sending feedback", message:"Mail must be set up on this device to send feedback", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}
