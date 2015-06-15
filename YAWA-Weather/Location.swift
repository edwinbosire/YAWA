//
//  Location.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 08/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {
	
	dynamic var locality: String = ""
	dynamic var municipality: String = ""
	dynamic var postalCode: String = ""
	dynamic var adminArea: String = ""
	dynamic var country: String = ""
	dynamic var latitude: Double = 0.0
	dynamic var longitude: Double = 0.0
	
}