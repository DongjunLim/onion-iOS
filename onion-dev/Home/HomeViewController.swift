//
//  HomeViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/18.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var feedList: FeedList! = nil
    var resultCount: Int = 0
    var feedManager = FeedManager()
    @IBOutlet weak var thumbnailCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        self.getHomeFeedThumbnail()
        
        super.viewDidLoad()
        searchBar.searchTextField.backgroundColor = UIColor.white
        self.thumbnailCollectionView.dataSource = self
        self.thumbnailCollectionView.delegate = self
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "goToFeedDetailViewHome" {
        }
    }
    func getHomeFeedThumbnail(){
        feedManager.getFeedList() { result in
            self.feedList = result
            self.resultCount = 10
            self.thumbnailCollectionView.reloadData()
            return
        };
    }
}

extension HomeViewController: UISearchBarDelegate {
    private func dismissKeyboard(){
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 키보드가 올라와 있을 때 내려가게 처리

        dismissKeyboard()
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
        
    }
    
    // 검색어가 있는지 확인
    
    
    // 네트워킹을 통한 검색
}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate
 {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        

        cell.feed = self.feedList?.feedList[indexPath[1]]
        FeedManager.getFeedImage(fileUrl: cell.feed!.feedThumbnailUrl) { result in
            cell.thumbnail.image = result
        }
        cell.thumbnail.layer.cornerRadius = 5
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let select = collectionView.cellForItem(at: indexPath) as! HomeCollectionViewCell
        let feedDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
        feedDetailVC.feedInfo = select.feed
        self.present(feedDetailVC, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 200, height: 175)
    }
}

