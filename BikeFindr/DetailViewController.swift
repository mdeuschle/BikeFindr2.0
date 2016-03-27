//
//  DetailViewController.swift
//  BikeFindr
//
//  Created by Matt Deuschle on 3/25/16.
//  Copyright © 2016 Matt Deuschle. All rights reserved.
//

import UIKit
import CoreLocation

class DetailViewController: UIViewController {

    @IBOutlet var detailImageView: UIImageView!
    @IBOutlet var stationName: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var availableBikes: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var latitude: UILabel!
    @IBOutlet var longitude: UILabel!

    var selectedBikeStation = Divvy()
    var currentLocation = CLLocation()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = selectedBikeStation.stationName
        stationName.text = selectedBikeStation.stationName
        status.text = selectedBikeStation.status
        availableBikes.text = "\(selectedBikeStation.availableBikes) bikes available"

        let distance = self.currentLocation.distanceFromLocation(CLLocation(latitude: selectedBikeStation.lat, longitude: selectedBikeStation.lon))
        let miles = distance * 0.000621371
        let bikeMiles = Double(round(10 * miles)/10)
        distanceLabel.text = "\(bikeMiles) mi"

        latitude.text = String(selectedBikeStation.lat)
        longitude.text = String(selectedBikeStation.lon)
    }

    @IBAction func onDirectionsPressed(sender: UIButton) {

    }

}
