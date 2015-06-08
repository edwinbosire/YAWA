//
//  Current.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 17/05/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation
import UIKit

struct Current {
    
    var currentTime: String?
    var temperature: Int
    var humidity: Double
    var precipProbability: Double
	var windSpeed: Int
	var windDirection: String?
    var summary: String
    var icon: UIImage?

    
    init(weatherDictionary: NSDictionary) {
        let currentWeather = weatherDictionary["currently"] as! NSDictionary
        
        temperature = currentWeather["temperature"] as! Int
        humidity = currentWeather["humidity"] as! Double
        precipProbability = currentWeather["precipProbability"] as! Double
		windSpeed = currentWeather["windSpeed"] as! Int
        summary = currentWeather["summary"] as! String
		
		let windDirectionDegrees  = currentWeather["windBearing"] as! Int
		windDirection = windDirectionFromDegress(windDirectionDegrees)
		
        let currentTimeIntVale = currentWeather["time"] as! Int
        currentTime = dateStringFromUnixTime(currentTimeIntVale)
        
        let iconString = currentWeather["icon"] as! String
        icon = Current.weatherIconFromString(iconString)
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