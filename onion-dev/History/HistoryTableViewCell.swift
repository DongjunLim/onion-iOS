//
//  HistoryTableViewCell.swift
//  onion-dev
//
//  Created by 임동준 on 2020/06/11.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit




class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var historyContent: UITextView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var feedThumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        historyContent.translatesAutoresizingMaskIntoConstraints = true
        historyContent.sizeToFit()
        historyContent.isScrollEnabled = false
        historyContent.isEditable = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
