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
	var delegate: LocationSearchDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Your Cities"
		self.tableView.tableFooterView = UIView.new()
		
		reloadData()
	}
	
	func reloadData() {
		cities = City.fetchCities()
		tableView.reloadData()
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
		
		var locationName = city.location.municipality
		if (locationName.isEmpty) {
			locationName = city.location.adminArea
		}
		if (locationName.isEmpty) {
			locationName = city.location.country
		}
		
		cell.titleLabel.text = locationName
		cell.timeLabel.text = city.weather.time
		cell.temperatureLabel.text = "\(city.weather.temperature)°C"
	
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
		
		let city = cities[indexPath.row]
		delegate?.didSelectCity(city, viewController:self)
	}
	
	func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
		
		var itemToMove = cities[sourceIndexPath.row]
		itemToMove.index = destinationIndexPath.row
		
		cities.removeAtIndex(sourceIndexPath.row)
		cities.insert(itemToMove, atIndex: destinationIndexPath.row)
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		
		if editingStyle == UITableViewCellEditingStyle.Delete{
			
			let city = cities[indexPath.row]
			StoreManager.sharedInstance.managedObjectContext?.deleteObject(city)
			
			self.editCities(editCitiesBarItem);
			reloadData()
		
		}
	}
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 70.0
	}
}