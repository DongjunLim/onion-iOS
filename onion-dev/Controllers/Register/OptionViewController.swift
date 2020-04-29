//
//  OptionViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/03/23.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class OptionViewController: UIViewController {
    var registerManager: RegisterManager?
    var userInfo: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerManager = RegisterManager()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        //옵션 유효성 검사
        let userEmail = userInfo["userEmail"]!
        let userNickname = userInfo["userId"]!
        let userPassword = userInfo["userPw"]!
        
        print(userEmail)
        print(userNickname)
        print(userPassword)
        
        
        //네트워크 전송
        registerManager!.join(email: String(userEmail), id: String(userNickname), pw: String(userPassword)) { token in
            DispatchQueue.main.async {
                UserDefaults.standard.set(token, forKey: "AccessToken")
            }
        }
        
        //화면전환
        self.performSegue(withIdentifier: "goToFinishView", sender: self)
    }

}
