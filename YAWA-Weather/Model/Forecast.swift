//
//  Forecast.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 15/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(Forecast)
class Forecast: NSManagedObject {

    @NSManaged var time: String
    @NSManaged var temperature: NSNumber
    @NSManaged var humidity: NSNumber
    @NSManaged var precipitationProbability: NSNumber
    @NSManaged var windSpeed: NSNumber
    @NSManaged var windDirection: String
    @NSManaged var summary: String
    @NSManaged var icon: String
    @NSManaged var weeklyForecast: NSSet
    @NSManaged var city: City

	class func createNewForecast() -> Forecast {
		let forecast = NSEntityDescription.insertNewObjectForEntityForName("Forecast", inManagedObjectContext: StoreManager.sharedInstance.managedObjectContext!) as! Forecast
		return forecast
	}

	class func forecastWithDictionary(weatherDictionary: NSDictionary) -> Forecast {
		
		let forecast = Forecast.createNewForecast()
		
		let currentWeather = weatherDictionary["currently"] as! NSDictionary
		
		forecast.temperature = currentWeather["temperature"] as! Int
		forecast.humidity = currentWeather["humidity"] as! Double
		forecast.precipitationProbability = currentWeather["precipProbability"] as! Double
		forecast.windSpeed = currentWeather["windSpeed"] as! Int
		forecast.summary = currentWeather["summary"] as! String
		forecast.icon = currentWeather["icon"] as! String

		let myWeeklyForecast = Forecast.weeklyForecastFromDictionary(weatherDictionary)
		let set = NSSet(array: myWeeklyForecast)
		forecast.weeklyForecast = set
	
		let windDirectionDegrees  = currentWeather["windBearing"] as! Int
		forecast.windDirection = forecast.windDirectionFromDegress(windDirectionDegrees)
		
		let currentTimeIntVale = currentWeather["time"] as! Int
		forecast.time = forecast.dateStringFromUnixTime(currentTimeIntVale)
		
		return forecast
	}

	func image() -> UIImage {
		return weatherIconFromString(icon)
	}
	
	class func weeklyForecastFromDictionary(weatherDictionary: NSDictionary) ->[Daily]{
		
		var weeklyForcasts = [Daily]()
		let weeklyWeather = weatherDictionary["daily"] as! NSDictionary
		let weeklyForcast = weeklyWeather["data"] as! NSArray
	
		for dailyDict in weeklyForcast {
			
			let dailyForecast = Daily.dailyWithDictionary(dailyDict as! NSDictionary)
			weeklyForcasts.append(dailyForecast)
		}
		
		return weeklyForcasts
	}
	
	func windDirectionFromDegress(degrees: Int) -> String {
		
		switch degrees {
		case (0...45):
			return "North"
		case (315...360):
			return "North"
		case (45...135):
			return "East"
		case (135...225):
			return "South"
		case (225...315):
			return "West"
		default:
			return "Unknown"
		}
		
	}
	
	func dateStringFromUnixTime(unixTime: Int) -> String {
		let timeInSeconds = NSTimeInterval(unixTime)
		let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
		
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "EEEE, MMM d"
		
		return dateFormatter.stringFromDate(weatherDate)
	}
	
	func dayOne() -> Daily {
		return weeklyForecast.allObjects[0] as! Daily
	}
	
	func dayTwo() -> Daily {
		return weeklyForecast.allObjects[1] as! Daily
	}
	
	func dayThree() -> Daily {
		return weeklyForecast.allObjects[2] as! Daily
	}
	
	func dayFour() -> Daily {
		return weeklyForecast.allObjects[3] as! Daily
	}
	
	func dayFive() -> Daily {
		return weeklyForecast.allObjects[4] as! Daily
	}

}
