//
//  ViewAnimations.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 16/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation
import UIKit

func springWithDelay(duration: NSTimeInterval, delay: NSTimeInterval, dampingRation: CGFloat = 0.7,  animations: (() -> Void)!) {
	
	UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: dampingRation, initialSpringVelocity: 0.8, options: .CurveEaseOut, animations: {
		
		animations()
		
		}, completion: { finished in
			
	})
}