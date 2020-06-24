//
//  TimelineViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/19.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    var refreshControl = UIRefreshControl()
    var feedList: FeedList! = nil
    var feedCount = 0
    var feedManager = FeedManager()
    @IBOutlet weak var thumbnailCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        self.getTimelineFeedThumbnail()
        thumbnailCollectionView.refreshControl = self.refreshControl
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    @objc func refresh(){
        getTimelineFeedThumbnail()
        self.refreshControl.endRefreshing()
    }
    
    
    func getTimelineFeedThumbnail(){

        self.feedManager.getTimelineFeedList() { result in
            self.feedList = result
            self.feedCount = self.feedList.feedList.count
            self.thumbnailCollectionView.reloadData()
            return
        };
    }
    
}

extension TimelineViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // 몇개 표시 할까?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedCount
    }
    
    // 셀 데이터 정의
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimelineCollectionViewCell", for: indexPath) as? TimelineCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.feed = self.feedList?.feedList[indexPath[1]]
        cell.username.setTitle(cell.feed?.authorNickname, for: .normal )
        
        FeedManager.getFeedImage(fileUrl: cell.feed!.feedThumbnailUrl) { result in
            cell.thumbnail.image = result
            FeedManager.getFeedImage(fileUrl: cell.feed!.profilePhotoURL){ profilePhotoImage in
                cell.userProfilePhoto.setImage(profilePhotoImage, for: .normal)
            }
        }
        
        return cell
    }
    
    //상세피드로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let select = collectionView.cellForItem(at: indexPath) as! TimelineCollectionViewCell
        let feedDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
        feedDetailVC.modalPresentationStyle = .fullScreen
        feedDetailVC.feedInfo = select.feed
        self.present(feedDetailVC, animated: true, completion: nil)
    }
}

extension TimelineViewController: UICollectionViewDelegateFlowLayout {
    // 셀 사이즈 어떻게 할까?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 115, height: 200)
    }
}
