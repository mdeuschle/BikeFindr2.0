//
//  Divvy.swift
//  BikeFindr
//
//  Created by Matt Deuschle on 3/25/16.
//  Copyright © 2016 Matt Deuschle. All rights reserved.
//

import Foundation
import CoreLocation

class Divvy {

    var stationName     = ""
    var availableBikes  = 0
    var lat             = 0.0
    var lon             = 0.0
    var status          = ""
    var distance        = 0.0
    var coordinate2D    = CLLocationCoordinate2D()

    func initWithData(data: [String:AnyObject], currentLocation: CLLocation) {

        stationName     = data["stAddress1"] as! String
        availableBikes  = Int(data["availableBikes"] as! Int)
        lat             = Double(data["latitude"] as! Double)
        lon             = Double(data["longitude"] as! Double)
        status          = data["statusValue"] as! String
        distance        = currentLocation.distanceFromLocation(CLLocation(latitude: lat, longitude: lon))
        coordinate2D    = CLLocationCoordinate2DMake(lat, lon)
    }
}


