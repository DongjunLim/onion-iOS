//
//  ProfileViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/19.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profilePhoto: UIImageView!
    var myProfile: Profile! = nil
    var feedList: FeedList! = nil
    var resultCount: Int = 0
    @IBOutlet weak var profileView: UICollectionView!
    
    override func viewDidLoad() {
        getUserFeedThumbnail()
        super.viewDidLoad()
    }

    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
        
    }
    func getUserFeedThumbnail(){
        FeedManager.getUserFeedList() { result in
            self.feedList = result
            self.resultCount = self.feedList.feedList.count
            print(self.feedList.feedList)
            self.profileView.reloadData()
            return
        };
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultCount
    }
    
    // 셀 어떻게 표시 할까?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileFeedThumbnailCollectionViewCell", for: indexPath) as? ProfileFeedThumbnailCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.layer.cornerRadius = 5
        if self.feedList?.feedList.count == nil{
            return cell
        }
                
        cell.feed = self.feedList?.feedList[indexPath[1]]
        
        FeedManager.getFeedImage(fileUrl: cell.feed!.feedThumbnailUrl) { result in
            cell.thumbnail.image = result
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        switch kind{
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileFeedThumbnailCollectionReusableView", for: indexPath) as? ProfileFeedThumbnailCollectionReusableView else {
                return UICollectionReusableView()
            }

            
            
            UserManager.getMyProfile(){ result in
                self.myProfile = result
                header.followCountLabel.text = String(self.myProfile.numOfFollowUser)
                header.followerCountLabel.text = String(self.myProfile.numOfFollower)
                header.userNicknameLabel.text = String(self.myProfile.userNickname)
                FeedManager.getFeedImage(fileUrl: self.myProfile.profilePhotoURL) { (result) in
                    header.profilePhoto.image = result
                    header.setProfilePhotoUI()
                }
            }
            
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.size.width
        let w = screenWidth / 3 - 15
        let h = w * 1.4
        return CGSize(width: w, height: h)
    }
}
