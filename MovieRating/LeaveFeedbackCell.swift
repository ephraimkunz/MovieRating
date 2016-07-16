//
//  LeaveFeedbackCell.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 7/16/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class LeaveFeedbackCell: UITableViewCell{
    var parentTableView: SettingsTableViewController?
    
    @IBAction func leaveFeedbackTapped(sender: AnyObject) {
        parentTableView!.launchMailComposer()
    }
}