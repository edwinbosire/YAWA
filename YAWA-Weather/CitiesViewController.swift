//
//  CitiesViewController.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 09/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class CitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var backButtonItem: UIBarButtonItem!
	@IBOutlet weak var editCitiesBarItem: UIBarButtonItem!
	
	let reuseIdentifier = "citiesCellReusableCell"
	var cities = Results<City>?()
	var delegate: LocationSearchDelegate?
	var storageManager: StorageManager?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Your Cities"
		self.tableView.tableFooterView = UIView.new()
		
		storageManager = StorageManager()
		
		reloadCitiesData()
	}
	
	func reloadCitiesData() -> Void {
		
		storageManager?.retrieveSortedCities({ (cities, error) -> () in
			
			self.cities = cities;
			self.tableView.reloadData()
		})
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
		if let collection = cities{
			return collection.count
		}
		
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		var cell: CitiesTableViewCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CitiesTableViewCell
		
		if let myCity = cities {
			
			let city = myCity[indexPath.row]
			
			if let cityLocation = city.location {
				
				var locationName = cityLocation.municipality
				if (locationName.isEmpty) {
					locationName = cityLocation.adminArea
				}
				if (locationName.isEmpty) {
					locationName = cityLocation.country
				}
				
				cell.titleLabel.text = locationName
			}
			
			if let cityWeather = city.weather {
				cell.timeLabel.text = cityWeather.currentTime
				cell.temperatureLabel.text = "\(cityWeather.temperature)°C"
				
			}
		}
		
		
		
		
		return cell
	}
	
	
	func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		let selectedCity = cities![indexPath.row]
		delegate?.didSelectCity(selectedCity, viewController: self)
	}
	
	func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
		
		var cityToMove = cities![sourceIndexPath.row]
		storageManager?.updateCityIndex(cityToMove, index:destinationIndexPath.row, completionHandler: { (success) -> () in
			
			self.reloadCitiesData()
		})
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		
		if editingStyle == UITableViewCellEditingStyle.Delete{
			var cityToDelete = cities![indexPath.row]
			
			storageManager?.deleteCity(cityToDelete, completionHandler: { (successful) -> () in
				
				self.reloadCitiesData()
			})
		}
	}
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 70.0
	}
}