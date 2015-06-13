//
//  LocationSearchDelegate.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 13/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation

protocol LocationSearchDelegate {
	
	func didPickLocation(selectedLocation: Location)
	func dismissSearchViewController()
}