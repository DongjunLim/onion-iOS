//
//  FeedCollectionReusableView.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/26.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class FeedCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var FeedImage: UIImageView!
    @IBOutlet weak var profilePhoto: UIButton!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    var isFollow: Bool = false
    
    @IBAction func followButtonPressedAfter(_ sender: UIButton) {
        if isFollow == false {
            //            followButton.backgroundColor = UIColor.black
            followButton.titleLabel?.textColor = UIColor.white
            followButton.titleLabel?.text = "팔로잉"
            isFollow = true
        } else{
            //            followButton.setbac = UIColor.white
            followButton.titleLabel?.textColor = UIColor.black
            followButton.titleLabel?.text = "팔로우"
            isFollow = false
        }
    }
    
    func updateUI(){
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.black.cgColor
        followButton.layer.cornerRadius = 5
    }
}
