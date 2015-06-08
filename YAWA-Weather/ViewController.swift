//
//  ViewController.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 17/05/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
	
	@IBOutlet weak var todaysWeatherIcon: UIImageView!
	@IBOutlet weak var todaysWeatherDateLabel: UILabel!
	@IBOutlet weak var todaysWeatherTemperatureLabel: UILabel!
	@IBOutlet weak var todaysWeatherWindSpeedLabel: UILabel!
	@IBOutlet weak var todaysWeatherWindDirectionLabel: UILabel!
	@IBOutlet weak var todaysWeatherHumidityLabel: UILabel!
	@IBOutlet weak var todaysWeatherWindSpeedIcon: UIImageView!
	@IBOutlet weak var todaysWeatherWindDirectionIcon: UIImageView!
	@IBOutlet weak var todaysWeatherHumidityIcon: UIImageView!
	
	
	@IBOutlet weak var weeklyForcastDayOneLabel: UILabel!
	@IBOutlet weak var weeklyForcastDayOneIcon: UIImageView!
	@IBOutlet weak var weeklyForcastDayOneTemperaturLabel: UILabel!
	
	
	@IBOutlet weak var weeklyForcastDayTwoLabel: UILabel!
	@IBOutlet weak var weeklyForcastDayTwoIcon: UIImageView!
	@IBOutlet weak var weeklyForcastDayTwoTemperatureLabel: UILabel!
	
	@IBOutlet weak var weeklyForcastDayThreeLabel: UILabel!
	@IBOutlet weak var weeklyForcastDayThreeIcon: UIImageView!
	@IBOutlet weak var weeklyForcastDayThreeTemperatureLabel: UILabel!
	
	
	@IBOutlet weak var weeklyForcastDayFourLabel: UILabel!
	@IBOutlet weak var weeklyForcastDayFourIcon: UIImageView!
	@IBOutlet weak var weeklyForcastDayFourTemperatureLabel: UILabel!
	
	
	@IBOutlet weak var weeklyForcastDayFiveLabel: UILabel!
	@IBOutlet weak var weeklyForcastDayFiveIcon: UIImageView!
	@IBOutlet weak var weeklyForcastDayFiveTemperatureLabel: UILabel!
	
	
	var locationManager: LocationManager!
	var locationCoordinates: CLLocationCoordinate2D!
	var doubleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = ""
		doubleTapGesture.numberOfTapsRequired = 2
		doubleTapGesture.addTarget(self, action: "doubleTapRefresh")
		self.view.addGestureRecognizer(doubleTapGesture)
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		refresh()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	func doubleTapRefresh() -> Void {
		refresh()
	}
	
	func getWeatherForLocation(longitude: CLLocationDegrees, latitude: CLLocationDegrees) -> Void {
		
		let forcastURL = NSURL(string:"\(latitude),\(longitude)", relativeToURL: Constants.BaseURL)!
		let sesssion  = NSURLSession.sharedSession()
		let downloadTask: NSURLSessionDownloadTask = sesssion.downloadTaskWithURL(forcastURL, completionHandler: { (locationURL: NSURL!, response:NSURLResponse!, error:NSError!) -> Void in
			
			if (error == nil) {
				
				let responseData = NSData(contentsOfURL: locationURL)!
				let weatherObj: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData, options: nil, error: nil) as! NSDictionary
				let currentWeather :Current = Current(weatherDictionary: weatherObj)
				let weeklyWeather :Weekly = Weekly(weatherDictionary: weatherObj)
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					
					self.populateScreenWithObject(currentWeather)
					self.populateScreenWithWeeklyData(weeklyWeather)
				})
				
			}else {
				
				let networkIssueAlertController = UIAlertController(title: "OOOPS!", message: "Ooopsy-daisy, we seem to be in  a spot of bother, please check your peripherals", preferredStyle: .Alert)
				
				let okButton = UIAlertAction(title: "Moving on", style: .Default, handler: { (action: UIAlertAction!) -> Void in
					println("Your grievances have been received, we'll attend to your misfortunes after tea")
				})
				
				networkIssueAlertController.addAction(okButton)
				
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					
					self.presentViewController(networkIssueAlertController, animated: true, completion: nil)
				})
			}
		})
		
		downloadTask.resume()
	}
	
	func populateScreenWithObject(currentWeather: Current) {
		
		if let icon = currentWeather.icon {
			self.todaysWeatherIcon.image = icon.tintWithColor(UIColor.blackColor())
		}
		if let time = currentWeather.currentTime {
			self.todaysWeatherDateLabel.text = "\(time.uppercaseString) "
		}
		
		self.todaysWeatherTemperatureLabel.text = "\(currentWeather.temperature)°"
		self.todaysWeatherWindSpeedLabel.text = "\(currentWeather.windSpeed) MPH"
		
		if let direction = currentWeather.windDirection {
			self.todaysWeatherWindDirectionLabel.text = "\(direction.uppercaseString)"
		}
		self.todaysWeatherHumidityLabel.text = "\(currentWeather.humidity) %"
		
	}
	
	func populateScreenWithWeeklyData(weeklyWeather: Weekly) {
		
		//Five day forcast
		let dayOne = weeklyWeather.dayOne()
		self.weeklyForcastDayOneTemperaturLabel.text = "\(dayOne.temperatureMax)"
		self.weeklyForcastDayOneIcon.image = dayOne.weatherIcon.tintWithColor(UIColor.blackColor())
		
		if let dayOneTime = dayOne.time {
			self.weeklyForcastDayOneLabel.text = dayOneTime.uppercaseString
		}
		
		let dayTwo = weeklyWeather.dayTwo()
		self.weeklyForcastDayTwoTemperatureLabel.text = "\(dayTwo.temperatureMax)"
		self.weeklyForcastDayTwoIcon.image = dayTwo.weatherIcon.tintWithColor(UIColor.blackColor())
		
		if let time = dayTwo.time {
			self.weeklyForcastDayTwoLabel.text = time.uppercaseString
		}
		
		let dayThree = weeklyWeather.dayThree()
		self.weeklyForcastDayThreeTemperatureLabel.text = "\(dayThree.temperatureMax)"
		self.weeklyForcastDayThreeIcon.image = dayThree.weatherIcon.tintWithColor(UIColor.blackColor())
		
		if let time = dayThree.time {
			self.weeklyForcastDayThreeLabel.text = time.uppercaseString
		}
		
		let dayFour = weeklyWeather.dayFour()
		self.weeklyForcastDayFourTemperatureLabel.text = "\(dayFour.temperatureMax)"
		self.weeklyForcastDayFourIcon.image = dayFour.weatherIcon.tintWithColor(UIColor.blackColor())
		
		if let time = dayFour.time {
			self.weeklyForcastDayFourLabel.text = time.uppercaseString
		}
		
		let dayFive = weeklyWeather.dayFive()
		self.weeklyForcastDayFiveTemperatureLabel.text = "\(dayFive.temperatureMax)"
		self.weeklyForcastDayFiveIcon.image = dayFive.weatherIcon.tintWithColor(UIColor.blackColor())
		
		if let time = dayFive.time {
			self.weeklyForcastDayFiveLabel.text = time.uppercaseString
		}
	}
	
	func refresh () {
		
		locationManager = LocationManager.init()
		locationManager.locationBlock = {(location: Location?, error: NSError?) -> Void in
			
			if error != nil {
				//Cannot get location raise warning
				NSLog("Could not retrieve location")
			}else {
				//update ui
				self.title = "\(location!.municipality), \(location!.locality)"
			}
		}
		
		locationManager.locationCoordinates = {(coordinates: CLLocationCoordinate2D) -> Void in
			self.locationCoordinates = coordinates
			self.getWeatherForLocation(coordinates.longitude, latitude: coordinates.latitude)
		}
		
		//1.Hide elemets
		
		self.todaysWeatherIcon.alpha = 0.0
		self.todaysWeatherDateLabel.alpha = 0.0
		self.todaysWeatherTemperatureLabel.alpha = 0.0
		self.todaysWeatherWindSpeedLabel.alpha = 0.0
		self.todaysWeatherWindDirectionLabel.alpha = 0.0
		self.todaysWeatherHumidityLabel.alpha = 0.0
		self.todaysWeatherWindSpeedIcon.alpha = 0.0
		self.todaysWeatherWindDirectionIcon.alpha = 0.0
		self.todaysWeatherHumidityIcon.alpha = 0.0
		self.weeklyForcastDayOneLabel.alpha = 0.0
		self.weeklyForcastDayOneIcon.alpha = 0.0
		self.weeklyForcastDayOneTemperaturLabel.alpha = 0.0
		self.weeklyForcastDayTwoLabel.alpha = 0.0
		self.weeklyForcastDayTwoIcon.alpha = 0.0
		self.weeklyForcastDayTwoTemperatureLabel.alpha = 0.0
		self.weeklyForcastDayThreeLabel.alpha = 0.0
		self.weeklyForcastDayThreeIcon.alpha = 0.0
		self.weeklyForcastDayThreeTemperatureLabel.alpha = 0.0
		self.weeklyForcastDayFourLabel.alpha = 0.0
		self.weeklyForcastDayFourIcon.alpha = 0.0
		self.weeklyForcastDayFourTemperatureLabel.alpha = 0.0
		self.weeklyForcastDayFiveLabel.alpha = 0.0
		self.weeklyForcastDayFiveIcon.alpha = 0.0
		self.weeklyForcastDayFiveTemperatureLabel.alpha = 0.0
		//2. Animate elements
		
		refreshAnimation()
		//3. Show elementes
		
		UIView.animateWithDuration(0.9, animations: { () -> Void in
			self.todaysWeatherIcon.alpha = 1.0
			self.todaysWeatherDateLabel.alpha = 1.0
			self.todaysWeatherTemperatureLabel.alpha = 1.0
			self.todaysWeatherWindSpeedLabel.alpha = 1.0
			self.todaysWeatherWindDirectionLabel.alpha = 1.0
			self.todaysWeatherHumidityLabel.alpha = 1.0
			self.todaysWeatherWindSpeedIcon.alpha = 1.0
			self.todaysWeatherWindDirectionIcon.alpha = 1.0
			self.todaysWeatherHumidityIcon.alpha = 1.0
			self.weeklyForcastDayOneLabel.alpha = 1.0
			self.weeklyForcastDayOneIcon.alpha = 1.0
			self.weeklyForcastDayOneTemperaturLabel.alpha = 1.0
			self.weeklyForcastDayTwoLabel.alpha = 1.0
			self.weeklyForcastDayTwoIcon.alpha = 1.0
			self.weeklyForcastDayTwoTemperatureLabel.alpha = 1.0
			self.weeklyForcastDayThreeLabel.alpha = 1.0
			self.weeklyForcastDayThreeIcon.alpha = 1.0
			self.weeklyForcastDayThreeTemperatureLabel.alpha = 1.0
			self.weeklyForcastDayFourLabel.alpha = 1.0
			self.weeklyForcastDayFourIcon.alpha = 1.0
			self.weeklyForcastDayFourTemperatureLabel.alpha = 1.0
			self.weeklyForcastDayFiveLabel.alpha = 1.0
			self.weeklyForcastDayFiveIcon.alpha = 1.0
			self.weeklyForcastDayFiveTemperatureLabel.alpha = 1.0
			
		})
	}
	
	func refreshAnimation() ->Void {
		
		
		self.todaysWeatherIcon.transform = CGAffineTransformMakeTranslation(-300, 0)
		self.todaysWeatherDateLabel.transform = CGAffineTransformMakeTranslation(300, 0)
		self.todaysWeatherTemperatureLabel.transform = CGAffineTransformMakeTranslation(0, -500)
		
		self.todaysWeatherWindSpeedLabel.transform = CGAffineTransformMakeTranslation(-300, 0)
		self.todaysWeatherWindSpeedIcon.transform = CGAffineTransformMakeTranslation(-300, 0)
		
		self.todaysWeatherWindDirectionLabel.transform = CGAffineTransformMakeTranslation(300, 0)
		self.todaysWeatherWindDirectionIcon.transform = CGAffineTransformMakeTranslation(-300, 0)
		
		self.todaysWeatherHumidityLabel.transform = CGAffineTransformMakeTranslation(300, 0)
		self.todaysWeatherHumidityIcon.transform = CGAffineTransformMakeTranslation(300, 0)
		
		self.weeklyForcastDayOneLabel.transform = CGAffineTransformMakeTranslation(0, 600)
		self.weeklyForcastDayOneIcon.transform = CGAffineTransformMakeTranslation(0, 600)
		self.weeklyForcastDayOneTemperaturLabel.transform = CGAffineTransformMakeTranslation(0, 600)
		
		self.weeklyForcastDayTwoLabel.transform = CGAffineTransformMakeTranslation(0, 600)
		self.weeklyForcastDayTwoIcon.transform = CGAffineTransformMakeTranslation(0, 600)
		self.weeklyForcastDayTwoTemperatureLabel.transform = CGAffineTransformMakeTranslation(0, 600)
		
		self.weeklyForcastDayThreeLabel.transform = CGAffineTransformMakeTranslation(0, 600)
		self.weeklyForcastDayThreeIcon.transform = CGAffineTransformMakeTranslation(0, 600)
		self.weeklyForcastDayThreeTemperatureLabel.transform = CGAffineTransformMakeTranslation(0, 600)
		
		self.weeklyForcastDayFourLabel.transform = CGAffineTransformMakeTranslation(0, 600)
		self.weeklyForcastDayFourIcon.transform = CGAffineTransformMakeTranslation(0, 600)
		self.weeklyForcastDayFourTemperatureLabel.transform = CGAffineTransformMakeTranslation(0, 600)
		
		self.weeklyForcastDayFiveLabel.transform = CGAffineTransformMakeTranslation(0, 600)
		self.weeklyForcastDayFiveIcon.transform = CGAffineTransformMakeTranslation(0, 600)
		self.weeklyForcastDayFiveTemperatureLabel.transform = CGAffineTransformMakeTranslation(0, 600)
		
		springWithDelay(0.9, delay: 0.45, dampingRation: 0.9, animations: {
			self.todaysWeatherIcon.transform = CGAffineTransformIdentity
		})
		
		
		springWithDelay(0.9, delay: 0.45, dampingRation: 0.8, animations: {
			self.todaysWeatherDateLabel.transform = CGAffineTransformIdentity
			
		})
		
		springWithDelay(0.9, delay: 0.45, animations: {
			self.todaysWeatherTemperatureLabel.transform = CGAffineTransformIdentity
		})
		
		
		springWithDelay(0.9, delay: 0.45, animations: {
			self.todaysWeatherWindSpeedLabel.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.45, dampingRation: 0.9, animations: {
			self.todaysWeatherWindDirectionLabel.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.45, animations: {
			self.todaysWeatherHumidityLabel.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.45, animations: {
			self.todaysWeatherWindSpeedIcon.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.45, dampingRation: 0.8, animations: {
			self.todaysWeatherWindDirectionIcon.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.45, animations: {
			self.todaysWeatherHumidityIcon.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.25, animations: {
			self.weeklyForcastDayOneLabel.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.26, animations: {
			self.weeklyForcastDayOneIcon.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.27, animations: {
			self.weeklyForcastDayOneTemperaturLabel.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.35, animations: {
			self.weeklyForcastDayTwoLabel.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.36, animations: {
			self.weeklyForcastDayTwoIcon.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.37, animations: {
			self.weeklyForcastDayTwoTemperatureLabel.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.45, animations: {
			self.weeklyForcastDayThreeLabel.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.46, animations: {
			self.weeklyForcastDayThreeIcon.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.47, animations: {
			self.weeklyForcastDayThreeTemperatureLabel.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.55, animations: {
			self.weeklyForcastDayFourLabel.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.56, animations: {
			self.weeklyForcastDayFourIcon.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.57, animations: {
			self.weeklyForcastDayFourTemperatureLabel.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.65, animations: {
			self.weeklyForcastDayFiveLabel.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.66, animations: {
			self.weeklyForcastDayFiveIcon.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.67, animations: {
			self.weeklyForcastDayFiveTemperatureLabel.transform = CGAffineTransformIdentity
		})
		
	}
	
	func springWithDelay(duration: NSTimeInterval, delay: NSTimeInterval, animations: (() -> Void)!) {
		
		UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: {
			
			animations()
			
			}, completion: { finished in
				
		})
		
	}
	func springWithDelay(duration: NSTimeInterval, delay: NSTimeInterval, dampingRation: CGFloat,  animations: (() -> Void)!) {
		
		UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: dampingRation, initialSpringVelocity: 0.8, options: nil, animations: {
			
			animations()
			
			}, completion: { finished in
				
		})
	}
	
}

