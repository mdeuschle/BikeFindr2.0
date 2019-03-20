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
    
//    var selectedBikeStation = Divvy()

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.title = selectedBikeStation.stationName.uppercased()
//        status.text = selectedBikeStation.status
//        availableBikes.text = "\(selectedBikeStation.availableBikes) Bikes Available"
//
//        let distance = self.currentLocation.distance(from: CLLocation(latitude: selectedBikeStation.lat, longitude: selectedBikeStation.lon))
//        let miles = distance * 0.000621371
//        let bikeMiles = Double(round(10 * miles)/10)
//        distanceLabel.text = "\(bikeMiles) Miles"
    }

//    @IBAction func onDirectionsPressed(sender: UIButton) {
//
//        bikeStationDirections(lat: selectedBikeStation.lat, lon: selectedBikeStation.lon)
//    }
//
//    func bikeStationDirections(lat: Double, lon: Double) {
//        let urlString = "http://maps.apple.com/maps?daddr=\(String(lat)),\(String(lon))"
//        guard let url = URL(string: urlString) else { return }
//        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//    }
}
