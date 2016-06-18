//
//  Utilities.swift
//  YAWA-Weather
//
//  Created by edwinbosire on 18/06/2016.
//  Copyright © 2016 Edwin Bosire. All rights reserved.
//

import Foundation


func dispatchMain(block:() -> Void) {
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        block()
    })
}