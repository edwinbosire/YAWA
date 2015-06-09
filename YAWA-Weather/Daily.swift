//
//  Daily.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 17/05/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation
import UIKit

struct Daily {
   
    var temperatureMax: Int
    var temperatureMin: Int
    var time: String?
    var weatherIcon: UIImage
	var hour: String?
    
    init (dailyForcast: NSDictionary) {
        
        temperatureMax = dailyForcast["temperatureMax"] as! Int
        temperatureMin = dailyForcast["temperatureMin"] as! Int
        let iconString = dailyForcast["icon"] as! String
        weatherIcon = Current.weatherIconFromString(iconString)
        let dayOneTimeIntValue = dailyForcast["sunriseTime"] as! Int
        time = weeekDateStringFromUnixtime(dayOneTimeIntValue)

    }
	
	init (tempMax: Int, tempMin: Int, weatherIcon: String, time: Int) {
		
		self.temperatureMax = tempMax
		self.temperatureMin = tempMin
		self.weatherIcon = Current.weatherIconFromString(weatherIcon)
		self.time = weeekDateStringFromUnixtime(time)
		self.hour = hourStringFromUnixtime(time)
	}
	
    func weeekDateStringFromUnixtime(unixTime: Int) -> String {
        
        let timeInSeconds = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
        
        let dateFormatter = NSDateFormatter()
        //dateFormatter.timeStyle = .MediumStyle
        dateFormatter.dateFormat = "EEE"
        
        return dateFormatter.stringFromDate(weatherDate)
		
    }
	
	func hourStringFromUnixtime(unixTime: Int) -> String {
		
		let timeInSeconds = NSTimeInterval(unixTime)
		let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.timeStyle = .ShortStyle
		
		return dateFormatter.stringFromDate(weatherDate)
		
	}
	

}