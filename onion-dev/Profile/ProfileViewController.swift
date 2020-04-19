//
//  ProfileViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/19.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var followButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        followButton.layer.borderColor = UIColor.black.cgColor
        followButton.layer.borderWidth = 1
        followButton.layer.cornerRadius = 7

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
