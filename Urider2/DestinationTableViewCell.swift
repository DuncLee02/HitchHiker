//
//  DestinationTableViewCell.swift
//  Urider2
//
//  Created by Duncan Lee on 3/14/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import UIKit

class DestinationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rideLabel: UILabel!
    @IBOutlet weak var requestLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
