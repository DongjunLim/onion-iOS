//
//  FeedDetailViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/26.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class FeedDetailViewController: UIViewController {
    var productView: UIView!
    var feedInfo: Feed? = nil
    var cellCount = 0
    var relativefeedList: FeedList?
    var feedManager = FeedManager()
    var replyList: ReplyList?
    @IBOutlet weak var FeedDetailCollectionView: UICollectionView!
    override func viewDidLoad() {
        FeedManager.getReplyList(feedId: String(feedInfo!.feedID)) { ReplyList in
            self.replyList = ReplyList
        }
        super.viewDidLoad()
        
        getRelativeFeedList(feedId: feedInfo!.feedID)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {

        
    }
    @IBAction func productTagButtonPressed(_ sender: UIButton) {
        moveProductView()
    }
    
    @IBAction func goToReplyViewButtonPreseed(_ sender: UIButton) {
        let replyVC = self.storyboard?.instantiateViewController(withIdentifier: "ReplyViewController") as! ReplyViewController
        replyVC.modalPresentationStyle = .fullScreen
        replyVC.feed = feedInfo
        replyVC.replyList = replyList
        self.present(replyVC, animated: true, completion: nil)
    }
    func moveProductView(){
        let productVC = ProductListViewController()
        productVC.modalPresentationStyle = .fullScreen
        self.performSegue(withIdentifier: "goToProductSegue", sender: self)
    }
    
    func getRelativeFeedList(feedId: String){
        print(feedId)

        feedManager.getRelativeFeedList(feedId:feedId){ result in
            self.relativefeedList = result
//            self.cellCount = result.feedList.count
            print("컨트롤러")
            if result.feedList.count > 10{
                self.cellCount = 10
            } else {
                self.cellCount = result.feedList.count
            }
            for (i,element) in self.relativefeedList!.feedList.enumerated() {
                if element.feedID == self.feedInfo?.feedID{
                    self.relativefeedList?.feedList.remove(at: i)
                    self.cellCount = self.relativefeedList?.feedList.count as! Int
                    break
                }
            }
            
            
            print("썸네일 숫자: \(self.cellCount)")
            self.FeedDetailCollectionView.reloadData()

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

            print(self.feedInfo!.photoUrl)
            FeedManager.getFeedImage(fileUrl: self.feedInfo!.photoUrl) { (result) in
                header.FeedImage.image = result
            }
            header.username.text = self.feedInfo?.authorNickname
            header.contentTextView.text = self.feedInfo?.content
            guard let cnt = replyList?.feedReplyList.count else {
                header.goToReplyViewButton.setTitle("댓글 작성하기", for: .normal)
                header.updateUI()
                return header
            }

            header.goToReplyViewButton.setTitle("댓글 \(cnt)개 모두 보기", for: .normal)
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


