//
//  Cities.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 09/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation
import RealmSwift

class City: Object {
	
	dynamic var weather: Forcast?
	dynamic var location: Location?
	dynamic var index: Int = 0
	
}


