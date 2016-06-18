//
//  Daily.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 15/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(Daily)
class Daily: NSManagedObject {

    @NSManaged var temperatureMax: NSNumber
    @NSManaged var temperatureMin: NSNumber
    @NSManaged var time: String
    @NSManaged var icon: String
    @NSManaged var currentForecast: NSManagedObject

	class func createNewDailyForecast() -> Daily {
		let daily = NSEntityDescription.insertNewObjectForEntityForName("Daily", inManagedObjectContext: StoreManager.sharedInstance.managedObjectContext!) as! Daily
		return daily
	}

	class func dailyWithDictionary(dailyForcast: NSDictionary) ->Daily {
		
		let daily = Daily.createNewDailyForecast()
		
		daily.temperatureMax = dailyForcast["temperatureMax"] as! Int
		daily.temperatureMin = dailyForcast["temperatureMin"] as! Int
		daily.icon = dailyForcast["icon"] as! String
		
		let dayOneTimeIntValue = dailyForcast["sunriseTime"] as! Int
		daily.time = weeekDateStringFromUnixtime(dayOneTimeIntValue)

		return daily
	}

	func image() -> UIImage {
		return  weatherIconFromString(icon)
	}
	
	
	func hourStringFromUnixtime(unixTime: Int) -> String {
		
		let timeInSeconds = NSTimeInterval(unixTime)
		let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.timeStyle = .ShortStyle
		
		return dateFormatter.stringFromDate(weatherDate)
		
	}
	

}
