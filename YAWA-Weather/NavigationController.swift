//
//  NavigationController.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 03/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.setBackgroundImage(UIImage(named: "navigationBarBackground"), forBarMetrics: .Default)
		self.navigationBar.shadowImage = UIImage.new()
		self.navigationBar.translucent = false
		
		var navigationBarAppearance = UINavigationBar.appearance()
		navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.blackColor(),
			NSFontAttributeName : UIFont(name: "Open Sans", size: 16.0)!]
    }

}

extension UINavigationBar {
	public override func sizeThatFits(size: CGSize) -> CGSize {
		var newsize: CGSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width, 60)
		return newsize
	}
}

