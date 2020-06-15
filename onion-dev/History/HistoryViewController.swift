//
//  HistoryViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/06/11.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit



class HistoryViewController: UIViewController {
    var history: History? = nil
    var historyCnt: Int = 0
    
    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        HistoryManager.getHistoryList{ result in
            self.history = result
            self.historyCnt = self.history!.userHistoryList.count
            self.historyTableView.reloadData()
        }
        
        historyTableView.rowHeight = UITableView.automaticDimension
        historyTableView.estimatedRowHeight = 50
        super.viewDidLoad()
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyCnt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        
        guard let now = self.history?.userHistoryList[indexPath[1]] else {
            return cell
        }
        
        
        let type = String(now.type)
        cell.profilePhoto.layer.cornerRadius = cell.profilePhoto.frame.height / 2
        
        switch type {
        case "follow":
            cell.feedThumbnail.isHidden = true
            cell.historyContent.text = "\(now.follower!)님이 회원님을 팔로우하기 시작했습니다."
        case "reply":
            FeedManager.getFeedImage(fileUrl: "photo/08daceb145f63c44d6e10d5831f7ed3ffbc6eff5") { (result) in
                cell.feedThumbnail.image = result
            }
            cell.feedThumbnail.isHidden = false
            cell.followButton.isHidden = true
            cell.historyContent.text = "\(now.writer!)님이 회원님의 게시글에 댓글을 남겼습니다."

        default:
            cell.historyContent.text = "좋아요"
        }
        
        
        return cell
    }
}
