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


