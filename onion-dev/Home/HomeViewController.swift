//
//  HomeViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/18.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var refreshControl = UIRefreshControl()
    var feedList: FeedList! = nil
    var resultCount: Int = 0
    var feedManager = FeedManager()
    @IBOutlet weak var thumbnailCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        
        // 썸네일 컬렉션뷰의 refreshControl을 컨트롤러의 refreshControl로 설정
        thumbnailCollectionView.refreshControl = self.refreshControl
        
        // 서버로부터 썸네일 리스트 받아옴
        self.getHomeFeedThumbnail()
        super.viewDidLoad()
        
        // 검색창 배경 설정
        searchBar.searchTextField.backgroundColor = UIColor.white
        
        // 컬렉션뷰 dataSource와 delegate 연동
        self.thumbnailCollectionView.dataSource = self
        self.thumbnailCollectionView.delegate = self
        
        // 새로고침
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        // 키보드 활성화 상태일때 다른 곳을 누르면 키보드가 내려가게 하는 함수
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    // 새로고침 함수
    @objc func refresh(){
        getHomeFeedThumbnail()
        self.refreshControl.endRefreshing()
    }

    // 상세피드화면으로 이동하는 메소드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "goToFeedDetailViewHome" {
        }
    }

    // 서버로부터 홈화면 썸네일 리스트를 받아옴
    func getHomeFeedThumbnail(){
        FeedManager.getHomeFeedList() { result in
            self.feedList = result
            self.resultCount = self.feedList.feedList.count
            self.thumbnailCollectionView.reloadData()
            return
        };
    }
}

extension HomeViewController: UISearchBarDelegate {
//    private func dismissKeyboard(){
//        searchBar.resignFirstResponder()
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // 키보드가 올라와 있을 때 내려가게 처리
        dismissKeyboard()
        
        // 검색어가 있는지 없는지 확인
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
        
        // 네트워킹을 통한 검색
        feedManager.getKeywordFeedList(keyword: searchTerm) { (result) in
            self.feedList = result
            self.resultCount = self.feedList.feedList.count
            self.thumbnailCollectionView.reloadData()
            return
        }
    }
    
    
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
        FeedManager.getFeedImage(fileUrl:cell.feed!.feedThumbnailUrl) { result in
            cell.thumbnail.image = result
        }
        cell.thumbnail.layer.cornerRadius = 5
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let select = collectionView.cellForItem(at: indexPath) as! HomeCollectionViewCell
        let feedDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedDetailViewController") as! FeedDetailViewController
        feedDetailVC.modalPresentationStyle = .fullScreen
        feedDetailVC.feedInfo = select.feed
        self.present(feedDetailVC, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 200, height: 175)
    }
}


extension HomeViewController {
    // 키보드말고 다른곳을 눌렀을때 키보드가 내려가게 하는 함수
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
