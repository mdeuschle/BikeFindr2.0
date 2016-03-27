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

//    var bikes = [Divvy]()

    var mapViewController: MapViewController!
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()

    override func viewDidLoad() {
        super.viewDidLoad()

        requestLocation()

        self.title = "BIKE FINDR"

        mapViewController = (self.tabBarController?.viewControllers?.first as! UINavigationController).viewControllers.first as! MapViewController
    }

//    override func viewWillAppear(animated: Bool) {
////
////        super.viewWillAppear(animated)
////        tableView.reloadData()
////    }

    override func viewDidAppear(animated: Bool) {

        tableView.reloadData()
    }

    func requestLocation() {

        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let currentLoc = locations.first {

            currentLocation = currentLoc
            tableView.reloadData()

            if currentLoc.verticalAccuracy < 1000 && currentLoc.horizontalAccuracy < 1000 {

                locationManager.stopUpdatingLocation()
            }
        }
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {

        print(error)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return mapViewController.bikes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! TableViewCell
        let bike: Divvy = mapViewController.bikes[indexPath.row]
        cell.bikeStationName.text = bike.stationName.uppercaseString
        cell.bikeAvailable.text = "\(String(bike.availableBikes)) bikes available"

        let distance = self.currentLocation.distanceFromLocation(CLLocation(latitude: bike.lat, longitude: bike.lon))

        let miles = distance * 0.000621371
        let bikeMiles = Double(round(10 * miles)/10)

        cell.milesLabel.text = "\(bikeMiles) mi"

        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let detailView = segue.destinationViewController as! DetailViewController

        let bike = mapViewController.bikes[(tableView.indexPathForSelectedRow!.row)]
        detailView.selectedBikeStation = bike
        detailView.currentLocation = self.currentLocation
    }
}









