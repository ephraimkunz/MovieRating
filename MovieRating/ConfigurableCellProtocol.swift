//
//  ConfigurableCellProtocol.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 7/4/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation

protocol ConfigurableCell {
    func configure(_ row: Int, data: MovieInfo)
}
