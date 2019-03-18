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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!

    var bikes = [Divvy]()

    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    let bikesAnnotaion = MKPointAnnotation()

    override func viewDidLoad() {
        super.viewDidLoad()

        requestLocation()
        downloadBikeStations()
//        setUpMapViewStart()

    }

//    func setUpMapViewStart() {
//        let chicagoCord = CLLocationCoordinate2D(latitude: 41.886257, longitude: -87.629875)
//        mapView.setRegion(MKCoordinateRegionMake(chicagoCord, MKCoordinateSpanMake(0.01, 0.01)), animated: false)
//    }

    func requestLocation() {

        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    func downloadBikeStations() {
        
        guard let url = URL(string: "http://www.divvybikes.com/stations/json") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let bikeStationData = try? JSONSerialization.jsonObject(with: data!,
                                                                       options: .allowFragments) as? [String: Any] {
                DispatchQueue.main.async {
                    self.configureData(data: bikeStationData! as [String : AnyObject])
                }
            }
        }
        task.resume()
    }

    func configureData(data: [String:AnyObject]) {

        let results = data["stationBeanList"] as! [[String:AnyObject]]

        for bikestation in results {
            let newBikeStation = Divvy()
            newBikeStation.initWithData(data: bikestation, currentLocation: self.currentLocation)
            bikes.append(newBikeStation)
        }
        bikes.sort(by: { $0.distance < $1.distance })
        dropPins()
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)

        mapView.setRegion(coordinateRegion, animated: true)
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {

        if let loc = userLocation.location {

            centerMapOnLocation(location: loc)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let currentLoc = locations.first {

            currentLocation = currentLoc
            if currentLoc.verticalAccuracy < 1000 && currentLoc.horizontalAccuracy < 1000 {

                locationManager.stopUpdatingLocation()
                centerMapOnLocation(location: currentLocation)
            }
        }
    }

    func dropPins() {

        for bike in bikes {

            let newPin = BikePointAnnotation()
            newPin.coordinate = bike.coordinate2D
            newPin.title = bike.stationName
            newPin.subtitle = "Bikes Available: \(bike.availableBikes)"
            newPin.bikeStation = bike
            mapView.addAnnotation(newPin)
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation.isEqual(mapView.userLocation) {
            return nil }

        let mapPin = MKAnnotationView()
        mapPin.canShowCallout = true
        mapPin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        mapPin.image = UIImage(named: "bikePin")
        return mapPin
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        print(error)
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {

        performSegue(withIdentifier: "DetailSeg", sender: nil)

    }

    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let detailView = segue.destination as! DetailViewController
        let selectedPoint = mapView.selectedAnnotations.first as! BikePointAnnotation
        detailView.selectedBikeStation = selectedPoint.bikeStation
        detailView.currentLocation = self.currentLocation
    }

    class BikePointAnnotation : MKPointAnnotation {

        var bikeStation : Divvy!
    }
}
