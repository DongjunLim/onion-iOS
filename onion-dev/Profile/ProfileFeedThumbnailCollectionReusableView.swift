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
    
    
    func setProfilePhotoUI(){
        self.profilePhoto.layer.cornerRadius =  self.profilePhoto.frame.height / 2
    }
    
    
    
        
}
