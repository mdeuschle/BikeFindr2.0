//
//  ListViewController.swift
//  BikeFindr
//
//  Created by Matt Deuschle on 3/25/16.
//  Copyright © 2016 Matt Deuschle. All rights reserved.
//

import UIKit
import CoreLocation

class ListViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    let locationManager = CLLocationManager()
    private var currentLocation = CLLocation()
    var inSearchMode = false
    private var bikes = [Divvy]() {
        didSet {
            tableView.reloadData()
        }
    }
    private var filteredBikes = [Divvy]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadBikeStations()
        configureSearchBar()
        setupTableView()
        setupLocation()
    }
    
    private func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        navigationItem.searchController = searchController
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
    
    private func getBike(at row: Int, inSearchMode: Bool) -> Divvy {
        return inSearchMode ? filteredBikes[row] : bikes[row]
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
                    guard let viewController = self else { return }
                    AlertController(viewController: viewController).showAlert(with: error)
                }
                self?.bikes.sort(by: { $0.distance < $1.distance })
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailView = segue.destination as? DetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
        let bike = getBike(at: indexPath.row, inSearchMode: inSearchMode)
        detailView.divvy = bike
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredBikes.count : bikes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableViewCell else {
            return TableViewCell()
        }
        var bike = getBike(at: indexPath.row, inSearchMode: inSearchMode)
        cell.configure(with: &bike)
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: indexPath,
                              animated: true)
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

extension ListViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            inSearchMode = true
            filteredBikes = bikes.filter {
                $0.stationBeanList.stationName!.lowercased().contains(text.lowercased())
            }
        } else {
            inSearchMode = false
            tableView.reloadData()
        }
    }
}








