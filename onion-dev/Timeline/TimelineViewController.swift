//
//  TimelineViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/19.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    var feedList: FeedList! = nil
    var feedCount = 0
    @IBOutlet weak var thumbnailCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTimelineFeedThumbnail()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        feedCount = 10
        self.thumbnailCollectionView.reloadData()
    }
    
    func getTimelineFeedThumbnail(){
        FeedManager.getFeedList() { result in
            self.feedList = result
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
        FeedManager.getFeedImage(fileUrl: cell.feed!.feedThumbnailUrl) { result in
            cell.thumbnail.image = result
        }
        return cell
    }
    
    //상세피드로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let select = collectionView.cellForItem(at: indexPath) as! TimelineCollectionViewCell
        let feedDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
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
