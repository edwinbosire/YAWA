//
//  Daily.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 17/05/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Daily: Object {
   
    dynamic var temperatureMax: Int = 0
    dynamic var temperatureMin: Int = 0
    dynamic var time: String = ""
    dynamic var weatherIcon: String = ""
	dynamic var hour: String = ""
	
    func dailyWithDictionary(dailyForcast: NSDictionary) {
        
        temperatureMax = dailyForcast["temperatureMax"] as! Int
        temperatureMin = dailyForcast["temperatureMin"] as! Int
        weatherIcon = dailyForcast["icon"] as! String
        let dayOneTimeIntValue = dailyForcast["sunriseTime"] as! Int
        time = weeekDateStringFromUnixtime(dayOneTimeIntValue)

    }
	
	func image() -> UIImage {
		return Forcast.weatherIconFromString(weatherIcon)
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