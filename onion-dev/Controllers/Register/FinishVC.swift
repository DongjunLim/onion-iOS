//
//  FinishVC.swift
//  onion-dev
//
//  Created by 임동준 on 2020/03/23.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class FinishVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        self.performSegue(withIdentifier: "goToHomeViewfromRegisterView", sender: self)
    }
    
}
