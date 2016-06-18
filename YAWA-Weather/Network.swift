//
//  Network.swift
//  YAWA-Weather
//
//  Created by edwinbosire on 18/06/2016.
//  Copyright © 2016 Edwin Bosire. All rights reserved.
//

import Foundation


func forcast(location: Location, callBack:(City?, NSError?) -> Void) {
    
    let forcastURL = NSURL(string:"\(location.latitude),\(location.longitude)", relativeToURL: Constants.BaseURL)!
    
    httpGet(forcastURL) { (response, error) in
        
        if let weatherObj = response {
            
            let myCity = City.fetchCityWithLocation(location)
            myCity.weather = Forecast.forecastWithDictionary(weatherObj)
            myCity.location = location
            
            callBack(myCity, error)
        }else {
            callBack(nil, error)
        }
    }
}

func httpGet(url: NSURL, callback: (NSDictionary?, NSError?) -> Void)  {
    let request = NSURLRequest(URL: url)
    let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    let task = session.dataTaskWithRequest(request) { (data, response, error) in
       
        do {
            let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            callback(jsonData, error)
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    task.resume()
}