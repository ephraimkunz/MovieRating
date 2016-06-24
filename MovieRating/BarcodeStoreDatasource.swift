//
//  BarcodeStoreDatasource.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 6/22/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import UIKit

class BarcodeStoreDatasource: NSObject, UITableViewDataSource{
    var data: [BarcodeData]
    override init(){
        data = BarcodeStore().getHistory()
    }
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellData = data[indexPath.row];
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
        cell.textLabel?.text = cellData.title
        cell.detailTextLabel?.text = cellData.barcode
        return cell
    }
    
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
}
