//
//  LocationManager.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 08/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
	
	var locationLock: Bool = false
	var seenError: Bool = false
	var locationStatus: String = "Not started"
	var locationBlock: ((Location?, NSError?) -> ())?
	var locationCoordinates: ((CLLocationCoordinate2D) -> ())?
	var locationManager: CLLocationManager!
	
	override init() {
		super.init()

		locationLock = false
		locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
		locationManager.requestWhenInUseAuthorization()

	}
	
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {

        locationManager.stopUpdatingLocation()
        
            if (seenError == false) {
                seenError = true
                print(error)
            }
    }

    
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
			var shouldAllow = false
		
		switch status {
		case .NotDetermined:
			locationManager.requestAlwaysAuthorization()
			break
		case .AuthorizedWhenInUse:
			locationStatus = "Allowed to location Access"
			shouldAllow = true
			locationManager.startUpdatingLocation()
			break
		case .AuthorizedAlways:
			locationStatus = "Allowed to location Access"
			shouldAllow = true
			locationManager.startUpdatingLocation()
			break
		case .Restricted:
			locationStatus = "Restricted Access to location"
			break
		case .Denied:
			locationStatus = "User denied access to location"
			break
		}
		
		if (shouldAllow == true) {
				NSLog("Location Allowed")
			} else {
				
				let error = NSError.init(domain: "Mercury", code: 0001, userInfo: ["userInfo" : locationStatus])
				if locationBlock != nil {
					locationBlock!(nil, error)
				}
			}
	}


    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = manager.location {
            
		CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [unowned self] (placemark, error) -> Void in
			self.locationManager.stopUpdatingLocation()
			
			if  placemark?.count > 0 {
				
				let myLocation = (placemark?.first)!
				let locationItem = Location.locationWithPlacemark(myLocation)
				
				if let locationBlock = self.locationBlock  {
					locationBlock(locationItem, nil)
				}
			}
		})
        }
		
		if (locationLock == false) {
			locationLock = true
		}
	}
	
	//MARK: Forward geocoding
	
	func searchForLocationWithName(name: String, completionHandler: ([Location], NSError?) ->()) -> () {
		
		var searchResultsLocations = [Location]()
		CLGeocoder().geocodeAddressString(name, completionHandler: { (placemarks, error) -> Void in
			
			if((error) != nil){
				
				print("Error", error)
			}
				
			else if let allPlacemarks = placemarks {
				
				NSLog(" there are \(allPlacemarks.count) locations found" )
				
				for aMark in allPlacemarks {
					
					let placemark:CLPlacemark = aMark as CLPlacemark
					let locationItem = Location.locationWithPlacemark(placemark)
					
					searchResultsLocations.append(locationItem)
					completionHandler(searchResultsLocations, error)
					
					print("\(placemark.administrativeArea)")
					
				}
			}
		
		})
		
		return
	}
}