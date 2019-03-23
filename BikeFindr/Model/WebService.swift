//
//  WebService.swift
//  BikeFindr
//
//  Created by Matt Deuschle on 3/17/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import Foundation
import CoreLocation

struct WebService {
    static let shared = WebService()
    private init() {}
    func dataTask(completion: @escaping (Response<Data>) -> Void) {
        let urlString = "http://www.divvybikes.com/stations/json"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            let response: Response<Data>
            if data != nil && error == nil {
                response = .success(data!)
            } else {
                response = .error(error)
            }
            completion(response)
        }
        task.resume()
    }
}


