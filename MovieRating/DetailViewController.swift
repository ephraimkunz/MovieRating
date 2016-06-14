//
//  DetailViewController.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 6/12/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation
import UIKit
class DetailViewController: UIViewController{
    var movieTitle: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imdbScore: UILabel!
    @IBOutlet weak var metaScore: UILabel!
    @IBOutlet weak var rottenTomatoesScore: UILabel!
   
    
    override func viewDidLoad() {
        if let movieTitle = movieTitle{
            titleLabel.text = movieTitle
            NetworkManager.getRatingForItemTitle(movieTitle){ json in
                if let imdb = json["imdbRating"] as? String, let meta = json["Metascore"] as? String, let tomato = json["tomatoRating"] as? String{
                    self.imdbScore.text = imdb
                    self.metaScore.text = meta
                    self.rottenTomatoesScore.text = tomato
                }
            }
        }
    }
}