//
//  ProfileFeedThumbnailCollectionViewCell.swift
//  onion-dev
//
//  Created by 임동준 on 2020/06/10.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class ProfileFeedThumbnailCollectionViewCell: UICollectionViewCell {
    var feed: Feed?
    
    @IBOutlet weak var thumbnail: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
