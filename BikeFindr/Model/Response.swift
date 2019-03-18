//
//  Response.swift
//  BikeFindr
//
//  Created by Matt Deuschle on 3/17/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import Foundation

enum Response<T> {
    case success(T)
    case error(Error?)
}
