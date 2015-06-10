//
//  Cities.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 09/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation

class City {
	
	var weather: Daily
	var city: String
	var index: Int = 0

	init(weather: Daily, city: String, order: Int?){
		
		self.weather = weather
		self.city = city
		
		if let ndx = order {
			self.index = ndx
		}
	}
}
