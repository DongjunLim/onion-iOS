//
//  FeedDetailViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/26.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class FeedDetailViewController: UIViewController {
    var feedInfo: Feed? = nil
    var cellCount = 0
    var relativefeedList: FeedList?
    
    @IBOutlet weak var FeedDetailCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getRelativeFeedList(feedId: "empty")

    }
    override func viewDidAppear(_ animated: Bool) {
        cellCount = 10
        FeedDetailCollectionView.reloadData()
        
    }
    
    
    func getRelativeFeedList(feedId: String){
        FeedManager.getFeedList(){ result in
            self.relativefeedList = result
        }
    }
}


extension FeedDetailViewController: UICollectionViewDataSource {
    // 몇개 표시 할까?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    // 셀 어떻게 표시 할까?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelativeThumbnailCollectionViewCell", for: indexPath) as? RelativeThumbnailCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.feed = self.relativefeedList?.feedList[indexPath[1]]
        
        FeedManager.getFeedImage(fileUrl: cell.feed!.feedThumbnailUrl) { result in
            cell.thumbnail.image = result
        }
        cell.thumbnail.layer.cornerRadius = 5
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        switch kind{
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FeedCollectionReusableView", for: indexPath) as? FeedCollectionReusableView else {
                return UICollectionReusableView()
            }
            
            
            FeedManager.getFeedImage(fileUrl: self.feedInfo!.photoUrl) { (result) in
                header.FeedImage.image = result
            }
            
            header.username.text = self.feedInfo?.authorNickname
            header.contentTextView.text = self.feedInfo?.content
            header.updateUI()
            
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let select = collectionView.cellForItem(at: indexPath) as! RelativeThumbnailCollectionViewCell
        let feedDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
        feedDetailVC.feedInfo = select.feed
        self.present(feedDetailVC, animated: true, completion: nil)
    }
    
    
    
}

extension FeedDetailViewController: UICollectionViewDelegateFlowLayout {
    // 셀 사이즈 어떻게 할까?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        
        return CGSize(width: 135, height: 180)
    }
}


