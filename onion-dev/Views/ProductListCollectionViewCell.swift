//
//  ProductListCollectionViewCell.swift
//  onion-dev
//
//  Created by 임동준 on 2020/05/18.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class ProductListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    var productUrl: String! = nil
    @IBOutlet weak var productPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
