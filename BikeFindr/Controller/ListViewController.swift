//
//  ListViewController.swift
//  BikeFindr
//
//  Created by Matt Deuschle on 3/25/16.
//  Copyright © 2016 Matt Deuschle. All rights reserved.
//

import UIKit
import CoreLocation

class ListViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet var tableView: UITableView!
    let locationManager = CLLocationManager()
//    @IBOutlet var searchBar: UISearchBar!

    private var bikes = [Divvy]() {
        didSet {
            tableView.reloadData()
        }
    }
    private var filteredBikes = [Divvy]()
    private var currentLocation = CLLocation()

    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        requestLocation()
        downloadBikeStations()
        setupTableView()
        setupLocation()
//        searchBar.delegate = self
//        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }
    
    private func setupLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    private func downloadBikeStations() {
        WebService.shared.dataTask { [weak self] response in
            DispatchQueue.main.async {
                switch response {
                case let .success(data):
                    if let json = try? JSONDecoder().decode(JSON.self, from: data) {
                        json.stationBeanList.forEach { stationBeanList in
                            if let divvy = Divvy(stationBeanList: stationBeanList,
                                                 currentLocation: self?.currentLocation) {
                                self?.bikes.append(divvy)
                            }
                        }
                    }
                case let .error(error):
                    print(error!)
                }
                self?.bikes.sort(by: { $0.distance < $1.distance })
            }
        }
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        tableView.reloadData()
//        view.endEditing(true)
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


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableViewCell else {
            return TableViewCell()
        }
        var bike = bikes[indexPath.row]
        cell.configure(with: &bike)
        
        
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

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inSearchMode {
            
            return filteredBikes.count
        }
        return bikes.count
    }
}

extension ListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if let currentLoc = locations.first {
            currentLocation = currentLoc
            if currentLoc.verticalAccuracy < 1000 && currentLoc.horizontalAccuracy < 1000 {
                locationManager.stopUpdatingLocation()
            }
        }
    }
}








