//
//  HomeCollectionViewCell.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/18.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!

    

    
    @IBOutlet weak var ThumbnailImageButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        let screenWidth = UIScreen.main.bounds.size.width
        self.thumbnail.bounds.size.width = screenWidth / 3 - 10
        self.thumbnail.bounds.size.height = self.thumbnail.bounds.size.width * 1.4

    }
    
}
