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
        
        
    }
    
}

extension ReplyViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    
    
    
    
}
