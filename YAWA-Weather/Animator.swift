//
//  Animator.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 13/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation
import UIKit

func springWithDelay(duration: NSTimeInterval, #delay: NSTimeInterval, #animations: (() -> Void)!) {
	
	UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: {
		
		animations()
		
		}, completion: { finished in
			
	})
	
}

func springWithDelay(duration: NSTimeInterval, #delay: NSTimeInterval, #dampingRation: CGFloat,  #animations: (() -> Void)!) {
	
	UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: dampingRation, initialSpringVelocity: 0.8, options: nil, animations: {
		
		animations()
		
		}, completion: { finished in
			
	})
}
	