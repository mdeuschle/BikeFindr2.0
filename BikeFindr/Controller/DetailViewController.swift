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
    @IBOutlet var addressLabel: UILabel!
    
    var divvy: Divvy?
    var station: StationBeanList?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = divvy?.stationBeanList.stationName
        station = divvy?.stationBeanList
        configureLabels()
    }
    
    private func configureLabels() {
        status.text = station?.statusValue
        if let bikesAvailable = station?.availableDocks {
            availableBikes.text = bikesAvailable.bikeString()
        } else {
            availableBikes.isHidden = true
        }
        distanceLabel.text = divvy?.distance.milesString()
        addressLabel.text = divvy?.stationBeanList.stAddress1
    }
    
    @IBAction func onDirectionsTapped(sender: UIButton) {
        guard let lat = station?.latitude,
            let lon = station?.longitude else { return }
        let urlString = "http://maps.apple.com/maps?daddr=\(String(lat)),\(String(lon))"
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
