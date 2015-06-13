//
//  SearchTableViewCell.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 12/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       titleLabel.text = ""
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
