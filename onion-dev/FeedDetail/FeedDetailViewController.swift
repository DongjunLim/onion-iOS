//
//  FeedDetailViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/26.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class FeedDetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}


extension FeedDetailViewController: UICollectionViewDataSource {
    // 몇개 표시 할까?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    // 셀 어떻게 표시 할까?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelativeThumbnailCollectionViewCell", for: indexPath) as? RelativeThumbnailCollectionViewCell else {
            return UICollectionViewCell()
        }
        let url = URL(string: "https://onionphotostorage.s3.ap-northeast-2.amazonaws.com/thumbnail/1-\(indexPath[1]+2).JPG")
        do{
            let data = try Data(contentsOf: url!)
            cell.thumbnail.image = UIImage(data: data)
        
            
        // Do any additional setup after loading the view.
        }catch let err{
            print("Error : \(err.localizedDescription)")

        }
//        let image: UIImage = UIImage(named:"\(indexPath[1]+1).jpg")!
        
        cell.thumbnail.layer.cornerRadius = 5
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        switch kind{
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FeedCollectionReusableView", for: indexPath) as? FeedCollectionReusableView else {
                return UICollectionReusableView()
            }
            header.followButton.layer.borderWidth = 1
            header.followButton.layer.borderColor = UIColor.black.cgColor
            header.followButton.layer.cornerRadius = 5
            return header
        default:
            return UICollectionReusableView()
        }
       
        
        
    }
}

extension FeedDetailViewController: UICollectionViewDelegateFlowLayout {
    // 셀 사이즈 어떻게 할까?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 20 - card(width) - 20 - card(width) - 20
        // TODO: 셀사이즈 구하기
//        let itemSpacing: CGFloat = 20
//        let margin: CGFloat = 20
//        let width = (collectionView.bounds.width -  itemSpacing - margin * 2) / 2
//        let height = width + 60
        
        return CGSize(width: 135, height: 180)
    }
}


