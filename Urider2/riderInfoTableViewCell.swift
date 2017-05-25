//
//  riderInfoTableViewCell.swift
//  Urider2
//
//  Created by Duncan Lee on 2/7/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import UIKit

class riderInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    
    var passenger: Rider!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
