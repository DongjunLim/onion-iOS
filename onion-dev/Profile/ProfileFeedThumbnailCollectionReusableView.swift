//
//  ProfileFeedThumbnailCollectionReusableView.swift
//  onion-dev
//
//  Created by 임동준 on 2020/06/10.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class ProfileFeedThumbnailCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followCountLabel: UILabel!
    @IBOutlet weak var userNicknameLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var editButton: UIButton!
    
    func setProfilePhotoUI(){
        self.profilePhoto.layer.cornerRadius =  self.profilePhoto.frame.height / 2
        self.updateButtonUI()
    }
    
    func updateButtonUI(){
        self.editButton.layer.cornerRadius = 5
        self.editButton.layer.borderWidth = 1
        self.editButton.layer.borderColor = UIColor.black.cgColor
        self.editButton.setTitleColor(.white, for: .normal)
        self.editButton.layer.backgroundColor = UIColor.black.cgColor
    }
    
        
}
