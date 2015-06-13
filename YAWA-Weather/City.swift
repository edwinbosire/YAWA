//
//  Cities.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 09/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation

struct City {
	
	var weather: Forcast?
	let location: Location?
	var index: Int = 0
	
	init(weather: Forcast?, location: Location, order: Int?){
		
		if let currentWeather = weather {
			self.weather = currentWeather
		}
		
		self.location = location
		
		if let ndx = order {
			self.index = ndx
		}
	}
}
