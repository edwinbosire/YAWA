//
//  City.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 15/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation
import CoreData

@objc(City)
class City: NSManagedObject {

    @NSManaged var index: NSNumber
    @NSManaged var weather: Forecast
    @NSManaged var location: Location

	class func createNewCity() -> City {
		let city = NSEntityDescription.insertNewObjectForEntityForName("City", inManagedObjectContext: StoreManager.sharedInstance.managedObjectContext!) as! City
		return city
	}
	
	class func fetchCities() -> [City] {
		let cities = StoreManager.sharedInstance.executeRequestWithPredicate(nil, entityName: "City") as! [City]
		return cities
	}
	
	class func fetchCityWithLocation(location: Location) ->City {
		let predicate = NSPredicate(format: "location.locality == %@ AND location.country == %@ ", location.locality, location.country)
		let cities = StoreManager.sharedInstance.executeRequestWithPredicate(predicate, entityName: "City") as! [City]
		
		if let aCity = cities.first {
			return aCity
		}else {
			let newCity = City.createNewCity()
			newCity.index = cities.count + 1
			return newCity
		}
	}
	
}
