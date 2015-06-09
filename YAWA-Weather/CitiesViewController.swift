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
		
		let londonWeather = Daily(tempMax: 20, tempMin: 10, weatherIcon: "clear-night", time: 1433796120)
		let london = City(weather: londonWeather, city: "London", order: 0)
		
		let moscowWeather = Daily(tempMax: 2, tempMin: 10, weatherIcon: "rain", time: 1433795120)
		let moscow = City(weather: moscowWeather, city: "Moscow", order: 1)

		let nairobiWeather = Daily(tempMax: 29, tempMin: 10, weatherIcon: "clear-day", time: 1433798120)
		let nairobi = City(weather: nairobiWeather, city: "Nairobi", order: 5)

		let	nycWeather = Daily(tempMax: 12, tempMin: 10, weatherIcon: "cloudy", time: 1433793520)
		let nyc = City(weather: londonWeather, city: "New York", order: 2)

		let beiginWeather = Daily(tempMax: 20, tempMin: 10, weatherIcon: "cloudy-night", time: 1433796420)
		let beigin = City(weather: londonWeather, city: "Beigin", order: 4)

		cities = [london, moscow, nairobi, nyc, beigin]
		
		cities.sort({ $0.index > $1.index })
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
		
		cell.titleLabel.text = city.city
		cell.timeLabel.text = city.weather.hour
		cell.temperatureLabel.text = "\(city.weather.temperatureMax)°C"
		
		
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