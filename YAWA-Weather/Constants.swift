//
//  Constants.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 17/05/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation


struct Constants {
    static let APIKey = "d0f2d7b4f0e23a0bf37a386ad905fc03"
    static let BaseURL: NSURL = NSURL(string: "https://api.forecast.io/forecast/\(APIKey)/")!
}