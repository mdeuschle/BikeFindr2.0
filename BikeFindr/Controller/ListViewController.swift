//
//  ListViewController.swift
//  BikeFindr
//
//  Created by Matt Deuschle on 3/25/16.
//  Copyright © 2016 Matt Deuschle. All rights reserved.
//

import UIKit
import CoreLocation

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!

    var bikes = [Divvy]()
    var filteredBikes = [Divvy]()

    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var inSearchMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
//
//        requestLocation()
//        downloadBikeStations()
//        searchBar.delegate = self
//        searchBar.returnKeyType = UIReturnKeyType.done
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        view.endEditing(true)
    }

    func requestLocation() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

//    func downloadBikeStations() {
//        
//        guard let url = URL(string: "http://www.divvybikes.com/stations/json") else { return }
//        let task = URLSession.shared.dataTask(with: url) { data, _, error in
//            if let bikeStationData = try? JSONSerialization.jsonObject(with: data!,
//                                                                       options: .allowFragments) as? [String: Any] {
//                DispatchQueue.main.async {
//                    self.configureData(data: bikeStationData! as [String : AnyObject])
//                }
//            }
//        }
//        task.resume()
//    }
//
//    func configureData(data: [String:AnyObject]) {
//        let results = data["stationBeanList"] as! [[String:AnyObject]]
//        for bikestation in results {
//            let newBikeStation = Divvy()
//            newBikeStation.initWithData(data: bikestation, currentLocation: self.currentLocation)
//            bikes.append(newBikeStation)
//            self.tableView.reloadData()
//        }
//        bikes.sort(by: { $0.distance < $1.distance })
//    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLoc = locations.first {
            currentLocation = currentLoc
            if currentLoc.verticalAccuracy < 1000 && currentLoc.horizontalAccuracy < 1000 {
                locationManager.stopUpdatingLocation()
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if inSearchMode {

            return filteredBikes.count
        }
            return bikes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
//
//        let bike: Divvy!
//
//        if inSearchMode {
//
//            bike = filteredBikes[indexPath.row]
//
//        } else {
//
//            bike = bikes[indexPath.row]
//        }
//
//        cell.bikeStationName.text = bike.stationName.uppercased()
//        cell.bikeAvailable.text = "\(String(bike.availableBikes)) bikes available"
//
//        let distance = self.currentLocation.distance(from: CLLocation(latitude: bike.lat, longitude: bike.lon))
//        let miles = distance * 0.000621371
//        let bikeMiles = Double(round(10 * miles)/10)
//        cell.milesLabel.text = "\(bikeMiles) mi"

        return cell
    }

//    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//
//        let detailView = segue.destination as! DetailViewController
//        detailView.currentLocation = self.currentLocation
//
//        let bike: Divvy!
//
//        if inSearchMode {
//
//            bike = filteredBikes[(tableView.indexPathForSelectedRow!.row)]
//            detailView.selectedBikeStation = bike
//        } else {
//
//            bike = bikes[(tableView.indexPathForSelectedRow!.row)]
//            detailView.selectedBikeStation = bike
//        }
//    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        view.endEditing(true)
    }

//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchBar.text == nil || searchBar.text == "" {
//
//            inSearchMode = false
//            view.endEditing(true)
//            tableView.reloadData()
//        } else {
//
//            inSearchMode = true
//            let searchText = searchBar.text!
//            filteredBikes = bikes.filter({ $0.stationName == searchText })
//            tableView.reloadData()
//        }
//    }
}









