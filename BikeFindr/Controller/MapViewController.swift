//
//  MapViewController.swift
//  BikeFindr
//
//  Created by Matt Deuschle on 3/25/16.
//  Copyright © 2016 Matt Deuschle. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    private var bikes = [Divvy]()
    private var currentLocation = CLLocation()
    let locationManager = CLLocationManager()
    let bikesAnnotaion = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocation()
        downloadBikeStations()
    }
    
    private func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    private func downloadBikeStations() {
        WebService.shared.dataTask(for: currentLocation) { [weak self] response in
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
                self?.dropPins()
            }
        }
    }
    
    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: 2000,
                                                  longitudinalMeters: 2000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func dropPins() {
        bikes.forEach { bike in
            let newPin = BikePointAnnotation()
            newPin.coordinate = bike.coordinate2D
            newPin.title = bike.stationBeanList.stationName
            if let availableBikes = bike.stationBeanList.availableDocks {
                newPin.subtitle = "Bikes Available: \(String(describing: availableBikes))"
            }
            newPin.bikeStation = bike
            mapView.addAnnotation(newPin)
        }
    }
    
//    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        guard let detailView = segue.destination as? DetailViewController,
//            let selectedPoint = mapView.selectedAnnotations.first as? BikePointAnnotation else { return }
//        detailView.selectedBikeStation = selectedPoint.bikeStation
//        detailView.currentLocation = self.currentLocation
//    }
    
    class BikePointAnnotation: MKPointAnnotation {
        var bikeStation: Divvy?
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if let currentLoc = locations.first {
            currentLocation = currentLoc
            if currentLoc.verticalAccuracy < 1000 && currentLoc.horizontalAccuracy < 1000 {
                centerMapOnLocation(location: currentLoc)
                locationManager.stopUpdatingLocation()
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isEqual(mapView.userLocation) {
            return nil }
        let mapPin = MKAnnotationView()
        mapPin.canShowCallout = true
        mapPin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        mapPin.image = UIImage(named: "bikePin")
        return mapPin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "DetailSeg", sender: nil)
    }
}
