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

    @IBOutlet weak var replyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replyTableView.rowHeight = UITableView.automaticDimension
        replyTableView.estimatedRowHeight = 50

        // Do any additional setup after loading the view.
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

extension ReplyViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    
    
    
    
}
