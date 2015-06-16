//
//  LocationSearchDelegate.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 13/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation
import UIKit

protocol LocationSearchDelegate {
	
	func didSelectLocation(selectedLocation: Location)
	
	func didSelectCity(city: City, viewController: UIViewController)
	
	func dismissSearchViewController(viewController : UIViewController)
}