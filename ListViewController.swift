//
//  ListViewController.swift
//  BikeFindr
//
//  Created by Matt Deuschle on 3/25/16.
//  Copyright © 2016 Matt Deuschle. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet var tableView: UITableView!

    var mapViewController: MapViewController!


    override func viewDidLoad() {
        super.viewDidLoad()

        mapViewController = (self.tabBarController?.viewControllers?.first as! UINavigationController).viewControllers.first as! MapViewController
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return mapViewController.bikes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        let bike: Divvy = mapViewController.bikes[indexPath.row]
        cell?.textLabel?.text = bike.stationName
        cell?.detailTextLabel?.text = bike.status

        return cell!
    }
}
