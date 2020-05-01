//
//  TimelineViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/19.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    @IBOutlet weak var thumbnailCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.thumbnailCollectionView.reloadData()

    }
    

    @IBAction func thumbnailPressed(_ sender: UIButton) {
        let FeedDetailVC = FeedDetailViewController()
        FeedDetailVC.modalPresentationStyle = .fullScreen
        self.performSegue(withIdentifier: "goToFeedDetailViewTimeline", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "goToFeedDetailViewTimeline" {
            
        }
    }

    
}

extension TimelineViewController: UICollectionViewDataSource {
    // 몇개 표시 할까?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("1")
        return 24
    }
    
    // 셀 어떻게 표시 할까?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimelineCollectionViewCell", for: indexPath) as? TimelineCollectionViewCell else {
            return UICollectionViewCell()
        }
        let image: UIImage = UIImage(named:"\(indexPath[1]+1).jpg")!
        cell.thumbnail.image = image
        return cell
    }
}

extension TimelineViewController: UICollectionViewDelegateFlowLayout {
    // 셀 사이즈 어떻게 할까?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = 135
//        let height = Float(width) * 1.7
        
        
        
        return CGSize(width: 115, height: 200)
    }
}
