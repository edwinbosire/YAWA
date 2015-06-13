//
//  CitiesViewController.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 09/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation
import UIKit

class CitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var backButtonItem: UIBarButtonItem!
	@IBOutlet weak var editCitiesBarItem: UIBarButtonItem!
	
	let reuseIdentifier = "citiesCellReusableCell"
	var cities: [City] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Your Cities"
		self.tableView.tableFooterView = UIView.new()
		
		//replace key = london with City.location.locality
		let key = "london"
		if let data = NSUserDefaults.standardUserDefaults().objectForKey(key) as? NSDictionary {
			
			let storedCurrentWeather :Forcast = Forcast(weatherDictionary: data)

			let loc = Location(locality: "London", municipality: "Greenwich", postalCode: "se13 7qf", administrationArea: "Greenwhich", county: "London")
			let london = City(weather: storedCurrentWeather, location: loc, order: 0)
			
			cities = [london]
			
		}
	}
	
	@IBAction func dismissCurrentView(sender: UIBarButtonItem) {
		navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
			
		})
	}
	
	@IBAction func editCities(sender: UIBarButtonItem) {
		
		if (self.tableView.editing){
			self.tableView.setEditing(false, animated: true)
			self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.title = "EDIT"
		}else {
			self.tableView.setEditing(true, animated: true)
			self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.title = "DONE"
		}
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cities.count;
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		var cell: CitiesTableViewCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CitiesTableViewCell
		
		let city = cities[indexPath.row]
		
		cell.titleLabel.text = city.location?.municipality
		cell.timeLabel.text = city.weather?.currentTime
		
		if let temp = city.weather?.temperature {
			cell.temperatureLabel.text = "\(temp)°C"
		}
		
		return cell
	}
	
	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}

	func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
		
		var itemToMove = cities[sourceIndexPath.row]
		itemToMove.index = destinationIndexPath.row
		
		cities.removeAtIndex(sourceIndexPath.row)
		cities.insert(itemToMove, atIndex: destinationIndexPath.row)
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		
		if editingStyle == UITableViewCellEditingStyle.Delete{
			cities.removeAtIndex(indexPath.row);
			self.editCities(editCitiesBarItem);
			tableView.reloadData();
		
		}
	}
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 70.0
	}
}