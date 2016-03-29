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
    @IBOutlet var searchBar: UISearchBar!

    var bikes = [Divvy]()

    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()

    override func viewDidLoad() {
        super.viewDidLoad()

        requestLocation()
        downloadBikeStations()
        searchBar.backgroundImage = UIImage()
    }


    override func viewDidAppear(animated: Bool) {

        tableView.reloadData()
    }

    func requestLocation() {

        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    func downloadBikeStations() {

        let url = NSURL(string: "http://www.divvybikes.com/stations/json")!
        let session = NSURLSession.sharedSession()

        session.dataTaskWithURL(url) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            do {
                if let bikeStationData = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String:AnyObject] {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.configureData(bikeStationData)
                    })
                }
            } catch {}
            }.resume()
    }

    func configureData(data: [String:AnyObject]) {

        let results = data["stationBeanList"] as! [[String:AnyObject]]

        for bikestation in results {
            let newBikeStation = Divvy()
            newBikeStation.initWithData(bikestation, currentLocation: self.currentLocation)
            bikes.append(newBikeStation)
            self.tableView.reloadData()
        }

        bikes.sortInPlace({ $0.0.distance < $0.1.distance })
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let currentLoc = locations.first {

            currentLocation = currentLoc

            if currentLoc.verticalAccuracy < 1000 && currentLoc.horizontalAccuracy < 1000 {

                locationManager.stopUpdatingLocation()
                tableView.reloadData()
            }
        }
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {

        print(error)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return bikes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! TableViewCell
        let bike = bikes[indexPath.row]
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

        let bike = bikes[(tableView.indexPathForSelectedRow!.row)]
        detailView.selectedBikeStation = bike
        detailView.currentLocation = self.currentLocation
    }
}









