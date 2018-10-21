//
//  AdventurerTableViewCell.swift
//  group3_assignment6
//
//  Created by Evan Shrestha on 10/19/18.
//  Copyright © 2018 Ivy, Connor R. All rights reserved.
//

import UIKit

class AdventurerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var adventurerName: UILabel!
    @IBOutlet weak var adventurerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
