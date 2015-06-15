//
//  storageManager.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 13/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation
import RealmSwift

class StorageManager: NSObject {
	
	let realm = Realm()
	
	func retrieveSortedCities(completionHandler:((Results<City>, NSError?) -> ())) {
		
		NSLog("StorageManager: retrieve sorted cities")
		let sortedCities = Realm().objects(City).sorted("index")
		completionHandler(sortedCities, nil)
	}
	
	func addCity(weather: Forcast, location: Location, index: Int, completionHandler:((City, Bool) -> ())?) {
		
		// 1. Search database for existing city and update it
		var cityResults = Realm().objects(City).filter("location.country = '\(location.country)'  AND location.municipality = '\(location.municipality)' ")
		var city = cityResults.first
		// 2. If no existing city create a new one
		
		if (city == nil) {
			city = City()
		}
		realm.write { () -> Void in
			city!.weather = weather;
			city!.location = location
			city!.index = index
			
			self.realm.add(city!)
		}
		
		completionHandler!(city!, true)
		NSLog("StorageManager: add city")
	}
	
	func updateCityWeather(city: City,weather: Forcast, completionHandler:((Bool) -> ())) {
		
		realm.write { () -> Void in
			city.weather = weather
		}
		
		NSLog("StorageManager: updatecity with weather")
	}
	
	func deleteCity(city: City, completionHandler:((Bool) -> ())?)  {
		
		realm.write { () -> Void in
			self.realm.delete(city)
			NSLog("StorageManager: delete city")

		}
	}
	
	func updateCityIndex(city: City, index: Int, completionHandler:((Bool) -> ()))  {
		realm.write { () -> Void in
			city.index = index
		}
		NSLog("StorageManager: update city's index")
	}
	
	func updateWeather(weather: Forcast, completionHandler:((Bool) -> ()))  {
		
		NSLog("StorageManager: update weather")
	}
	
}

