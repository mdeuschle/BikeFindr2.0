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

    @IBOutlet var status: UILabel!
    @IBOutlet var availableBikes: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    
    var selectedBikeStation = Divvy()
    var currentLocation = CLLocation()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = selectedBikeStation.stationName.uppercaseString
        status.text = selectedBikeStation.status
        availableBikes.text = "\(selectedBikeStation.availableBikes) Bikes Available"

        let distance = self.currentLocation.distanceFromLocation(CLLocation(latitude: selectedBikeStation.lat, longitude: selectedBikeStation.lon))
        let miles = distance * 0.000621371
        let bikeMiles = Double(round(10 * miles)/10)
        distanceLabel.text = "\(bikeMiles) Miles"
    }

    @IBAction func onDirectionsPressed(sender: UIButton) {

        bikeStationDirections(selectedBikeStation.lat, lon: selectedBikeStation.lon)
    }

    func bikeStationDirections(lat: Double, lon: Double) {

        UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/maps?daddr=\(String(lat)),\(String(lon))")!)
    }

}
