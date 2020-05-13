//
//  TimelineCollectionViewCell.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/19.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class TimelineCollectionViewCell: UICollectionViewCell {
    
    var feed: Feed?
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var username: UIButton!
    @IBOutlet weak var userProfilePhoto: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let screenWidth = UIScreen.main.bounds.size.width
        self.bounds.size.width = screenWidth / 3 - 10
        self.thumbnail.bounds.size.width = screenWidth / 3 - 10
        self.thumbnail.bounds.size.height = self.thumbnail.bounds.size.width * 1.6
    }
}
