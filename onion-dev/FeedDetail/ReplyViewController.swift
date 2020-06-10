//
//  ReplyViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/05/12.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {
    var replyList: ReplyList?
    var feed: Feed?
    @IBOutlet weak var editReplyTextView: UITextView!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var replyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replyTableView.rowHeight = UITableView.automaticDimension
        replyTableView.estimatedRowHeight = 50

        // Do any additional setup after loading the view.
    }
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        FeedManager.addReply(feedId: feed!.feedID, content: editReplyTextView.text!) { statusCode in
            if statusCode == 201{
                FeedManager.getReplyList(feedId: self.feed!.feedID) { (ReplyList) in
                    self.replyList = ReplyList
                    self.replyTableView.reloadData()
                }
            }
        }
    }
}

extension ReplyViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cnt = replyList?.feedReplyList.count else {
            return 0
        }
        return cnt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}
