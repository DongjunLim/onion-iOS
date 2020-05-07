//
//  SplashViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/05/05.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit
import KeychainSwift

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard KeychainSwift().get("AccessToken") != nil else{
            moveLoginView()
            return
        }
        // 서버에서 토큰 검증할 수 있는 로직 추가해야함
        
        self.moveMainView()
    }
    
    func moveMainView(){
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        self.performSegue(withIdentifier: "goToMainTabView", sender: self)
    }
    
    func moveLoginView(){
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        self.performSegue(withIdentifier: "goToLoginView", sender: self)
    }
}
