//
//  menuTableViewCell.swift
//  Urider2
//
//  Created by Duncan Lee on 4/6/17.
//  Copyright © 2017 Duncan Lee. All rights reserved.
//

import UIKit

class menuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
