//
//  ViewController.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 17/05/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var latestRefreshTime: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.title = "GREENWICH, LONDON"
//        refreshData(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func refreshData(sender: AnyObject) {
        
        refreshButton.hidden = true
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        getWeather()
    }

    func getWeather () -> Void {
        
        let forcastURL = NSURL(string:"51.472698,-0.021107", relativeToURL: Constants.BaseURL)!
        let sesssion  = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sesssion.downloadTaskWithURL(forcastURL, completionHandler: { (locationURL: NSURL!, response:NSURLResponse!, error:NSError!) -> Void in
         
            if (error == nil) {
            
                let responseData = NSData(contentsOfURL: locationURL)!
                let weatherObj: NSDictionary = NSJSONSerialization.JSONObjectWithData(responseData, options: nil, error: nil) as! NSDictionary
                let currentWeather :Current = Current(weatherDictionary: weatherObj)
                let weeklyWeather :Weekly = Weekly(weatherDictionary: weatherObj)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.populateScreenWithObject(currentWeather)
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
        
//        self.temperatureLabel.text = "\(currentWeather.temperature)"
//        self.weatherIcon.image = currentWeather.icon!
//        self.latestRefreshTime.text = "At \(currentWeather.currentTime!) it is"
//        self.humidityLabel.text = "\(currentWeather.humidity)"
//        self.precipitationLabel.text = "\(currentWeather.precipProbability)"
//        self.summaryLabel.text = "\(currentWeather.summary)"
		
		
    }
}

