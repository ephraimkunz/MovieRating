//
//  DetailViewController.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 6/12/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation
import UIKit
import Cosmos
import ChameleonFramework

class DetailViewController: UIViewController{
    var movieTitle: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imdbRating: CosmosView!
    @IBOutlet weak var rottenTomatoesRating: CosmosView!
    @IBOutlet weak var metaRating: CosmosView!
   
    
    override func viewDidLoad() {
        if let movieTitle = movieTitle{

            titleLabel.text = movieTitle
            NetworkManager.getRatingForItemTitle(movieTitle){ json in
                if let imdb = json["imdbRating"] as? NSString{
                    self.imdbRating.hidden = false
                    let imdbDouble = imdb.doubleValue
                    self.imdbRating.rating = imdbDouble
                    
                }else{
                    self.imdbRating.hidden = true
                }
                
                if let meta = json["Metascore"] as? NSString{
                    self.metaRating.hidden = false
                    let metaDouble = meta.doubleValue / 10.0
                    self.metaRating.rating = metaDouble
                    
                }else{
                    self.metaRating.hidden = true
                }
                
                if let tomato = json["tomatoRating"] as? NSString{
                    self.rottenTomatoesRating.hidden = false
                    let tomatoDouble = tomato.doubleValue
                    self.rottenTomatoesRating.rating = tomatoDouble
                    
                }else{
                    self.rottenTomatoesRating.hidden = true
                }
                
                if self.imdbRating.rating < 6.0{
                    self.navigationController?.navigationBar.barTintColor = UIColor.flatRedColor()
                    
                }
            }
        }
    }
}