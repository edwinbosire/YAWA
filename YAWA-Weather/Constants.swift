//
//  Constants.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 17/05/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let APIKey = "d0f2d7b4f0e23a0bf37a386ad905fc03"
    static let BaseURL: NSURL = NSURL(string: "https://api.forecast.io/forecast/\(APIKey)/")!
}

func weatherIconFromString(stringIcon: String) -> UIImage {
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

func weeekDateStringFromUnixtime(unixTime: Int) -> String {
	
	let timeInSeconds = NSTimeInterval(unixTime)
	let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
	
	let dateFormatter = NSDateFormatter()
	//dateFormatter.timeStyle = .MediumStyle
	dateFormatter.dateFormat = "EEE"
	
	return dateFormatter.stringFromDate(weatherDate)
	
}
