//
//  ListViewController.swift
//  BikeFindr
//
//  Created by Matt Deuschle on 3/25/16.
//  Copyright © 2016 Matt Deuschle. All rights reserved.
//

import UIKit
import CoreLocation


class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {


    @IBOutlet var tableView: UITableView!

    var mapViewController: MapViewController!
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapViewController = (self.tabBarController?.viewControllers?.first as! UINavigationController).viewControllers.first as! MapViewController
    }

    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let currentLoc = locations.first {

            currentLocation = currentLoc
            if currentLoc.verticalAccuracy < 1000 && currentLoc.horizontalAccuracy < 1000 {

                locationManager.stopUpdatingLocation()
            }
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return mapViewController.bikes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! TableViewCell
        let bike: Divvy = mapViewController.bikes[indexPath.row]
        cell.bikeStationName.text = bike.stationName
        cell.bikeAvailable.text = "\(String(bike.availableBikes)) bikes available"

        let distance = self.currentLocation.distanceFromLocation(CLLocation(latitude: bike.lat, longitude: bike.lon))

        let miles = distance * 0.000621371
        let bikeMiles = Double(round(10 * miles)/10)

        cell.milesLabel.text = "\(bikeMiles) mi"

        return cell
    }
}
