//
//  Divvy.swift
//  BikeFindr
//
//  Created by Matt Deuschle on 3/25/16.
//  Copyright © 2016 Matt Deuschle. All rights reserved.
//

import Foundation
import CoreLocation

struct JSON: Decodable {
    let stationBeanList: [StationBeanList]
}

struct StationBeanList: Decodable {
    let stationName: String?
    let availableDocks: Int?
    let latitude: Double?
    let longitude: Double?
    let statusValue: String?
    let stAddress1: String?
}

struct Divvy {
    let stationBeanList: StationBeanList
    var distance: Double
    var coordinate2D: CLLocationCoordinate2D
    init?(stationBeanList: StationBeanList?, currentLocation: CLLocation?) {
        guard let stationBeanList = stationBeanList,
            let lat = stationBeanList.latitude,
            let lon = stationBeanList.longitude,
            let currentLocation = currentLocation else { return nil }
        self.stationBeanList = stationBeanList
        let location = CLLocation(latitude: lat, longitude: lon)
        self.distance = currentLocation.distance(from: location)
        coordinate2D = CLLocationCoordinate2DMake(lat, lon)
    }
}

//class Divvy {
//
//    var stationName     = ""
//    var availableBikes  = 0
//    var lat             = 0.0
//    var lon             = 0.0
//    var status          = ""
//    var distance        = 0.0
//    var coordinate2D    = CLLocationCoordinate2D()
//
//    func initWithData(data: [String:AnyObject], currentLocation: CLLocation) {
//
//        stationName     = data["stAddress1"] as! String
//        availableBikes  = Int(data["availableBikes"] as! Int)
//        lat             = Double(data["latitude"] as! Double)
//        lon             = Double(data["longitude"] as! Double)
//        status          = data["statusValue"] as! String
//        distance        = currentLocation.distance(from: CLLocation(latitude: lat, longitude: lon))
//        coordinate2D    = CLLocationCoordinate2DMake(lat, lon)
//    }
//}


