//
//  AlertController.swift
//  BikeFindr
//
//  Created by Matt Deuschle on 3/23/19.
//  Copyright © 2019 Matt Deuschle. All rights reserved.
//

import UIKit

struct AlertController {
    let viewController: UIViewController
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func showAlert(with error: Error?) {
        let alert = UIAlertController(title: nil,
                                      message: error?.localizedDescription,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .cancel,
                                   handler: nil)
        alert.addAction(action)
        viewController.present(alert,
                               animated: true,
                               completion: nil)
    }
}
