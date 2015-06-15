//
//  Weekly.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 17/05/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Weekly: Object {
    
	let weeklyForcasts = List<Daily>()

	func weatherWithDictionary (weatherDictionary: NSDictionary) -> Void {
		
		let weeklyWeather = weatherDictionary["daily"] as! NSDictionary
		
		let weeklyForcast = weeklyWeather["data"] as! NSArray
		
		for dailyDict in weeklyForcast {
			
			let dailyForcast = Daily()
			dailyForcast.dailyWithDictionary(dailyDict as! NSDictionary)
			weeklyForcasts.append(dailyForcast)
		}
		
	}
	func dayOne() -> Daily {
		return weeklyForcasts[0]
	}
	
	func dayTwo() -> Daily {
		return weeklyForcasts[1]
	}
	
	func dayThree() -> Daily {
		return weeklyForcasts[2]
	}
	
	func dayFour() -> Daily {
		return weeklyForcasts[3]
	}
	
	func dayFive() -> Daily {
		return weeklyForcasts[4]
	}

}


func weeekDateStringFromUnixtime(unixTime: Int) -> String {
    
    let timeInSeconds = NSTimeInterval(unixTime)
    let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "EEE"
    
    return dateFormatter.stringFromDate(weatherDate)
    
    
}


