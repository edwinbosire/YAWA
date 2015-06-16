//
//  Location.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 15/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

@objc(Location)
class Location: NSManagedObject {

    @NSManaged var locality: String
    @NSManaged var municipality: String
    @NSManaged var postalCode: String
    @NSManaged var adminArea: String
    @NSManaged var county: String
    @NSManaged var country: String
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var city: NSManagedObject
	
	class func locationWithPlacemark(placemark: CLPlacemark) -> Location {
		
		let locality = (placemark.locality != nil) ? placemark.locality : ""
		let postalCode = (placemark.postalCode != nil) ? placemark.postalCode : ""
		let administrativeArea = (placemark.administrativeArea != nil) ? placemark.administrativeArea : ""
		let country = (placemark.country != nil) ? placemark.country : ""
		let municipality = (placemark.subLocality != nil) ? placemark.subLocality : ""
		let name = (placemark.name.isEmpty) ? "" : placemark.name
		
		var coordinates:CLLocationCoordinate2D = placemark.location.coordinate
		
		var location = Location.createNewLocation()
		
		location.locality = locality
		location.municipality = municipality
		location.postalCode = postalCode
		location.adminArea = administrativeArea
		location.country = country
		location.county = name
		location.latitude = coordinates.latitude
		location.longitude = coordinates.longitude
		
		return location
	}
	
	class func createNewLocation() -> Location {
		let location = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: StoreManager.sharedInstance.managedObjectContext!) as! Location
		return location
	}
	
	
	func searchForLocationWithLocality(locality: String, administration: String, country: String) ->Location {
		let predicate = NSPredicate(format: "locality == %@ AND country == %@ AND adminArea == %@ ", locality, country, administration)
		let location = StoreManager.sharedInstance.executeRequestWithPredicate(predicate, entityName: "Location") as! [Location]
		return location.last!
	}
}
