//
//  IntExtension.swift
//  BikeFindr
//
//  Created by Matt Deuschle on 3/20/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import Foundation

extension Int {
    func bikeString() -> String {
        let available = self >= 1 ? " Bikes" : " Bike"
        return String(self) + available + " Available"
    }
}
