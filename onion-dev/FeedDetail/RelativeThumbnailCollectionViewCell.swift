//
//  RelativeThumbnailCollectionViewCell.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/26.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class RelativeThumbnailCollectionViewCell: UICollectionViewCell {
    
    var feed: Feed?
    
    @IBOutlet weak var thumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
