//
//  TableViewCell.swift
//  BikeFindr
//
//  Created by Matt Deuschle on 3/25/16.
//  Copyright © 2016 Matt Deuschle. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var bikeStationName: UILabel!
    @IBOutlet var bikeAvailable: UILabel!
    @IBOutlet var milesLabel: UILabel!
    
    func configure(with bike: inout Divvy) {
        let station = bike.stationBeanList
        bikeStationName.text = station.stationName
        bikeAvailable.text = station.availableDocks?.bikeString()
        milesLabel.text = bike.distance.milesString()
    }
}
