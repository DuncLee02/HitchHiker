//
//  markerListTableViewCell.swift
//  Urider2
//
//  Created by Duncan Lee on 2/22/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import UIKit

class markerListTableViewCell: UITableViewCell {

    
    //@IBOutlet weak var postImageView:UIImageView!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var startPointLabel:UILabel!
    @IBOutlet weak var numberSeatsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var viewButton: UIButton!
    
    
    @IBOutlet weak var roundTripIcon: UIImageView!
    @IBOutlet weak var rideOrRequestIcon: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
}
