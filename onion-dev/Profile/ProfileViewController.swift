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
    var refreshControl = UIRefreshControl()
    var myProfile: Profile! = nil
    var feedList: FeedList! = nil
    var bookmarkList: FeedList! = nil
    var bookmarkCount: Int = 0
    var resultCount: Int = 0
    var currentView: UIView?
    var newView: UIView?
    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    @IBOutlet weak var profileView: UICollectionView!
    override func viewDidLoad() {
        profileCollectionView.refreshControl = self.refreshControl
        
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
        getUserFeedThumbnail()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        super.viewDidLoad()
    }
    
    // 새로고침 함수
    @objc func refresh(){
        self.getUserFeedThumbnail()
        self.refreshControl.endRefreshing()
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            getUserFeedThumbnail()
        } else if sender.selectedSegmentIndex == 1{
            getBookmarkFeedThumbnail()
        }
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        self.present(editVC, animated: true, completion: nil)
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
            self.profileView.reloadData()
            return
        }
    }
    
    
    func getBookmarkFeedThumbnail(){
        FeedManager.getUserBookmarkFeedList { (result) in
            self.feedList = result
            self.resultCount = self.feedList.feedList.count
            self.profileView.reloadData()
            return
        }
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

            
            header.setProfilePhotoUI()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let select = collectionView.cellForItem(at: indexPath) as! ProfileFeedThumbnailCollectionViewCell
        let feedDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
        feedDetailVC.feedInfo = select.feed
        feedDetailVC.modalPresentationStyle = .fullScreen
        self.present(feedDetailVC, animated: true, completion: nil)
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
