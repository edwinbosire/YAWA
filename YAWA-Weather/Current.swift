//
//  Forcast.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 17/05/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Forcast: Object {
    
    dynamic var currentTime: String = ""
    dynamic var temperature: Int = 0
    dynamic var humidity: Double = 0.0
    dynamic var precipProbability: Double = 0.0
	dynamic var windSpeed: Int = 0
	dynamic var windDirection: String = ""
    dynamic var summary: String = ""
    dynamic var icon: String = ""
	dynamic var weeklyForcast: Weekly?
	
    func forcastWithDictionar(weatherDictionary: NSDictionary) -> Void{
		
        let currentWeather = weatherDictionary["currently"] as! NSDictionary
        
        temperature = currentWeather["temperature"] as! Int
        humidity = currentWeather["humidity"] as! Double
        precipProbability = currentWeather["precipProbability"] as! Double
		windSpeed = currentWeather["windSpeed"] as! Int
        summary = currentWeather["summary"] as! String
		
		let windDirectionDegrees  = currentWeather["windBearing"] as! Int
		windDirection = self.windDirectionFromDegress(windDirectionDegrees)
		
        let currentTimeIntVale = currentWeather["time"] as! Int
        currentTime = dateStringFromUnixTime(currentTimeIntVale)
        
        icon = currentWeather["icon"] as! String
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
	
	func image() ->UIImage {
		
		return Forcast.weatherIconFromString(icon)
	}
	
  static  func weatherIconFromString(stringIcon: String) -> UIImage {
        var imageName: String
        
        switch stringIcon {
        case "clear-day":
            imageName = "clear-day"
        case "clear-night":
            imageName = "clear-night"
        case "rain":
            imageName = "rain"
        case "snow":
            imageName = "snow"
        case "sleet":
            imageName = "sleet"
        case "wind":
            imageName = "wind"
        case "fog":
            imageName = "fog"
        case "cloudy":
            imageName = "cloudy"
        case "partly-cloudy-day":
            imageName = "partly-cloudy"
        case "partly-cloudy-night":
            imageName = "cloudy-night"
        default:
            imageName = "default"
        }
        
        var iconName = UIImage(named: imageName)
        return iconName!
    }

}