//
//  RecruitmentImageCollectionViewCell.swift
//  group3_assignment6
//
//  Created by Evan Shrestha on 10/25/18.
//  Copyright © 2018 Ivy, Connor R. All rights reserved.
//

import UIKit

class RecruitmentImageCollectionViewCell:
UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                self.backgroundColor = UIColor.gray
            }
            else
            {
                self.backgroundColor = UIColor.white
            }
        }
    }
}
