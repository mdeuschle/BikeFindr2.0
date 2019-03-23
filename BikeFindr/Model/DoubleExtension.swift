//
//  DoubleExtension.swift
//  BikeFindr
//
//  Created by Matt Deuschle on 3/20/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import Foundation

extension Double {
    mutating func milesString() -> String {
        let miles = self * 0.000621371
        let bikeMiles = Double(Darwin.round(10 * miles)/10)
        return "\(bikeMiles) miles"
    }
}
