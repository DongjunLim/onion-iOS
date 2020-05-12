//
//  ReplyTableViewCell.swift
//  onion-dev
//
//  Created by 임동준 on 2020/05/12.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class ReplyTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userProfilePhoto: UIButton!
    @IBOutlet weak var replyContentView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        replyContentView.text = "consectetaur"
        replyContentView.translatesAutoresizingMaskIntoConstraints = true
        replyContentView.sizeToFit()
        replyContentView.isScrollEnabled = false
        replyContentView.isEditable = false
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
