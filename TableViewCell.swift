//
//  TableViewCell.swift
//  BikeFindr
//
//  Created by Matt Deuschle on 3/25/16.
//  Copyright © 2016 Matt Deuschle. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var bikeImage: UIImageView!
    @IBOutlet var bikeStationName: UILabel!
    @IBOutlet var bikeAvailable: UILabel!
    @IBOutlet var milesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }
}
