//
//  LocationSearchDelegate.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 13/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation

protocol LocationSearchDelegate {
	
	func didSelectCity(selectedCity: City, viewController: AnyObject)
	func didSelectLocation(selectedLocation: Location, viewController: AnyObject)
	func dismissViewController(ViewController: AnyObject)
}