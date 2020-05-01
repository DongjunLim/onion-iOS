//
//  HomeViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/18.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var resultCount: Int = 0
    @IBOutlet weak var thumbnailCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchTextField.backgroundColor = UIColor.white
        
    }
    override func viewDidAppear(_ animated: Bool) {
        resultCount = 18
        self.thumbnailCollectionView.reloadData()
    }
    

    @IBAction func swipeAction(_ sender: UISwipeGestureRecognizer) {
        if(sender.direction == .left){
            print("swipe Left")
        } else if(sender.direction == .right){
            print("swipe Right")
        } else if(sender.direction == .up){
            print("swipe Up")
        } else if(sender.direction == .down){
            print("swipe down")
        }
        
        self.view.endEditing(true)
    }
    
    
    @IBAction func goToFeedDetailView(_ sender: UIButton) {
        let FeedDetailVC = FeedDetailViewController()
        FeedDetailVC.modalPresentationStyle = .fullScreen
        self.performSegue(withIdentifier: "goToFeedDetailViewHome", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "goToFeedDetailViewHome" {
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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


extension HomeViewController: UICollectionViewDataSource {
    // 몇개 표시 할까?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultCount
    }
    
    // 셀 어떻게 표시 할까?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let url = URL(string: "https://onionphotostorage.s3.ap-northeast-2.amazonaws.com/thumbnail/\(indexPath[1]+26).jpg")
        do{
            let data = try Data(contentsOf: url!)
            cell.thumbnail.image = UIImage(data: data)
        // Do any additional setup after loading the view.
        }catch let err{
            print("Error : \(err.localizedDescription)")
        }
        cell.thumbnail.layer.cornerRadius = 5
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    // 셀 사이즈 어떻게 할까?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 20 - card(width) - 20 - card(width) - 20
        // TODO: 셀사이즈 구하기
//        let itemSpacing: CGFloat = 20
//        let margin: CGFloat = 20
//        let width = (collectionView.bounds.width -  itemSpacing - margin * 2) / 2
//        let height = width + 60
        
        return CGSize(width: 200, height: 175)
    }
}

