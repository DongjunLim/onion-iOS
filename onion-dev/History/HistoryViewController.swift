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
        super.viewDidLoad()
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
}
