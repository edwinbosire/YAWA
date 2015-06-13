//
//  Location.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 08/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation


class Location {
	var locality: String
	var municipality: String
	var postalCode: String
	var adminArea: String
	var county: String
	var latitude: Double = 0.0
	var longitude: Double = 0.0
	
	init(locality: String, municipality: String, postalCode: String, administrationArea: String, county: String) {
		
		self.locality = locality
		self.municipality = municipality
		self.postalCode = postalCode
		self.adminArea = administrationArea
		self.county = county
	}
	
}