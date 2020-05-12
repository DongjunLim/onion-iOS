//
//  FeedCollectionReusableView.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/26.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class FeedCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var goToReplyViewButton: UIButton!
    @IBOutlet weak var FeedImage: UIImageView!
    @IBOutlet weak var profilePhoto: UIButton!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    var isFollow: Bool = false
        
    func updateUI(){
        followButton.layer.borderWidth = 1
        followButton.backgroundColor = UIColor.white

        followButton.layer.borderColor = UIColor.black.cgColor
        followButton.layer.cornerRadius = 5
        followButton.setTitle("팔로우", for: .normal)
        username.text = "Jack"
        
    }
    
    
    @IBAction func goToReplyViewButtonPressed(_ sender: UIButton) {
        
        
    }
    
    
    
    @IBAction func followButtonPressed(_ sender: UIButton) {
        if followButton.backgroundColor == UIColor.white{
            UserManager.follow(targetUserNickname: username.text!) { statusCode in
                print(statusCode)
                if statusCode == 201{
                    self.followButton.backgroundColor = UIColor.black
                    self.followButton.setTitleColor(.white, for: .normal)
                    self.followButton.setTitle("팔로잉", for: .normal)
                }
            }
        }
        else{
            UserManager.unFollow(targetUserNickname: username.text!){ statusCode in
                if statusCode == 200{
                    self.followButton.backgroundColor = UIColor.white
                    self.followButton.setTitleColor(.black, for: .normal)
                    self.followButton.setTitle("팔로우", for: .normal)
                }
            }
        }
    }
    
}
