//
//  ViewController.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 17/05/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, LocationSearchDelegate {
	
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
	var searchDisplayViewController: SearchDisplayViewController!
	var cititesViewController: CitiesViewController!
	var locationCoordinates: CLLocationCoordinate2D!
	var doubleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
	var myCity: City?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = ""
		doubleTapGesture.numberOfTapsRequired = 2
		doubleTapGesture.addTarget(self, action: "doubleTapRefresh")
		self.view.addGestureRecognizer(doubleTapGesture)
		
		//		refresh()
		
	}
	
	func doubleTapRefresh() -> Void {
		refresh()
	}
	
	
	@IBAction func presentSearchViewController(sender: AnyObject) {
		
		searchDisplayViewController = storyboard?.instantiateViewControllerWithIdentifier("searchDisplay") as! SearchDisplayViewController
		searchDisplayViewController?.delegate  = self
		var navigation = NavigationController(rootViewController: searchDisplayViewController)
		
		self.navigationController?.presentViewController(navigation, animated: true, completion: nil)
	}
	
	@IBAction func presentCitiesListViewController(sender: AnyObject) {
		
		cititesViewController = storyboard?.instantiateViewControllerWithIdentifier("cityListDisplay") as! CitiesViewController
		cititesViewController?.delegate  = self
		var navigation = NavigationController(rootViewController: cititesViewController)
		
		self.navigationController?.presentViewController(navigation, animated: true, completion: nil)
		
	}
	
	func getWeatherForLocation(location: Location, city: City?) -> Void {
		
		let forcastURL = NSURL(string:"\(location.latitude),\(location.longitude)", relativeToURL: kBaseURL)!
		let sesssion  = NSURLSession.sharedSession()
		let downloadTask: NSURLSessionDownloadTask = sesssion.downloadTaskWithURL(forcastURL, completionHandler: { (locationURL: NSURL!, response:NSURLResponse!, error:NSError!) -> Void in
			
			if (error == nil) {
				
				let responseData = NSData(contentsOfURL: locationURL)!
				let weatherObj: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData, options: nil, error: nil) as! NSDictionary
				let currentWeather :Forcast = Forcast()
				var weeklyForecast = Weekly()

				
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					
					let storageManager = StorageManager()
					
					storageManager.realm.write({ () -> Void in
						
						currentWeather.forcastWithDictionar(weatherObj)
						weeklyForecast.weatherWithDictionary(weatherObj)
						currentWeather.weeklyForcast = weeklyForecast

					})
					storageManager.addCity(currentWeather, location: location, index:0, completionHandler: { (city, successful) -> () in
						
						self.populateScreenWithObject(currentWeather)
						self.myCity = city
						
						let altTitle = (location.locality.isEmpty) ? "\(location.adminArea)" : "\(location.locality), "
						var adminArea = (location.municipality.isEmpty) ? "\(altTitle)" : "\(location.municipality), "
						adminArea = (adminArea.isEmpty) ? "\(location.country)" : "\(adminArea)"
						self.title = "\(adminArea)"
						
					})
					
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
	
	// MARK: Populate screen with data
	
	func populateScreenWithObject(currentWeather: Forcast) {
		
		self.todaysWeatherIcon.image = currentWeather.image().tintWithColor(UIColor.blackColor())
		
		self.todaysWeatherDateLabel.text = "\(currentWeather.currentTime.uppercaseString) "
		
		
		self.todaysWeatherTemperatureLabel.text = "\(currentWeather.temperature)°"
		self.todaysWeatherWindSpeedLabel.text = "\(currentWeather.windSpeed) MPH"
		
		self.todaysWeatherWindDirectionLabel.text = "\(currentWeather.windDirection.uppercaseString)"
		
		self.todaysWeatherHumidityLabel.text = "\(currentWeather.humidity) %"
		
		
		//Five day forcast
		
		if let weeklyWeather = currentWeather.weeklyForcast {
			
			let dayOne = weeklyWeather.dayOne()
			self.weeklyForcastDayOneTemperaturLabel.text = "\(dayOne.temperatureMax)"
			self.weeklyForcastDayOneIcon.image = dayOne.image().tintWithColor(UIColor.blackColor())
			
			self.weeklyForcastDayOneLabel.text = dayOne.time.uppercaseString
			
			let dayTwo = weeklyWeather.dayTwo()
			self.weeklyForcastDayTwoTemperatureLabel.text = "\(dayTwo.temperatureMax)"
			self.weeklyForcastDayTwoIcon.image = dayTwo.image().tintWithColor(UIColor.blackColor())
			self.weeklyForcastDayTwoLabel.text = dayTwo.time.uppercaseString
			
			let dayThree = weeklyWeather.dayThree()
			self.weeklyForcastDayThreeTemperatureLabel.text = "\(dayThree.temperatureMax)"
			self.weeklyForcastDayThreeIcon.image = dayThree.image().tintWithColor(UIColor.blackColor())
			self.weeklyForcastDayThreeLabel.text = dayThree.time.uppercaseString
			
			let dayFour = weeklyWeather.dayFour()
			self.weeklyForcastDayFourTemperatureLabel.text = "\(dayFour.temperatureMax)"
			self.weeklyForcastDayFourIcon.image = dayFour.image().tintWithColor(UIColor.blackColor())
			self.weeklyForcastDayFourLabel.text = dayFour.time.uppercaseString
			
			let dayFive = weeklyWeather.dayFive()
			self.weeklyForcastDayFiveTemperatureLabel.text = "\(dayFive.temperatureMax)"
			self.weeklyForcastDayFiveIcon.image = dayFive.image().tintWithColor(UIColor.blackColor())
			self.weeklyForcastDayFiveLabel.text = dayFive.time.uppercaseString
		}
	}
	
	// MARK: Animation + Refresh
	
	func refresh() {
		
		locationManager = LocationManager.init()
		locationManager.locationBlock = {(location: Location?, error: NSError?) -> Void in
			
			if error != nil {
				NSLog("Could not retrieve location")
			}else {
				self.title = "\(location!.municipality), \(location!.locality)"
				
				if let loc = location {
					self.getWeatherForLocation(loc, city: self.myCity!)
				}
			}
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
		
		UIView.animateWithDuration(0.0, animations: { () -> Void in
			
			self.todaysWeatherIcon.transform = CGAffineTransformMakeTranslation(-300, 0)
			self.todaysWeatherDateLabel.transform = CGAffineTransformMakeTranslation(300, 0)
			self.todaysWeatherTemperatureLabel.transform = CGAffineTransformMakeTranslation(0, -500)
			
			self.todaysWeatherWindSpeedLabel.transform = CGAffineTransformMakeTranslation(-250, 0)
			self.todaysWeatherWindSpeedIcon.transform = CGAffineTransformMakeTranslation(-250, 0)
			
			self.todaysWeatherWindDirectionLabel.transform = CGAffineTransformMakeTranslation(300, 0)
			self.todaysWeatherWindDirectionIcon.transform = CGAffineTransformMakeTranslation(300, 0)
			
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
			
		})
		
		springWithDelay(0.9, delay: 0.45, dampingRation: 0.9, animations: {
			self.todaysWeatherIcon.transform = CGAffineTransformIdentity
		})
		
		
		springWithDelay(0.9, delay: 0.45, dampingRation: 0.8, animations: {
			self.todaysWeatherDateLabel.transform = CGAffineTransformIdentity
			
		})
		
		springWithDelay(0.9, delay: 0.45, animations: {
			self.todaysWeatherTemperatureLabel.transform = CGAffineTransformIdentity
		})
		
		
		springWithDelay(0.9, delay: 0.65, animations: {
			self.todaysWeatherWindSpeedLabel.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.65, animations: {
			self.todaysWeatherWindDirectionLabel.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.45, animations: {
			self.todaysWeatherHumidityLabel.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.45, animations: {
			self.todaysWeatherWindSpeedIcon.transform = CGAffineTransformIdentity
		})
		
		springWithDelay(0.9, delay: 0.45, animations: {
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
	
	//MARK: Location Delegate
	
	func dismissViewController(viewController: AnyObject) {
		let vc = viewController as! UIViewController
		vc.dismissViewControllerAnimated(true, completion:nil)
	}
	
	func didSelectLocation(selectedLocation: Location, viewController: AnyObject) {
		
		let searchVC = viewController as! SearchDisplayViewController
		searchVC.dismissViewControllerAnimated(true, completion:nil)

		self.getWeatherForLocation(selectedLocation, city: nil)
		
	}
	
	func didSelectCity(selectedCity: City, viewController: AnyObject) {
		
		let listVC = viewController as! CitiesViewController
		listVC.dismissViewControllerAnimated(true, completion:nil)
		
		if let cityWeather = selectedCity.weather {
			populateScreenWithObject(cityWeather)
		}
		
		if let cityLocation = selectedCity.location {
			getWeatherForLocation(cityLocation, city: selectedCity)
		}
	}
}

