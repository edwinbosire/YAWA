//
//  CitiesTableViewCell.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 09/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import Foundation
import UIKit

class CitiesTableViewCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var weatherIcon: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		self.titleLabel.text = ""
		self.timeLabel.text = ""
		self.temperatureLabel.text = ""
//		self.weatherIcon.image = UIImage(named: "partly-cloudy")
	}
	
}
