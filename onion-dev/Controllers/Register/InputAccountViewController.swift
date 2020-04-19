//
//  InputAccountViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/03/22.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class InputAccountViewController: UIViewController {

    var userInfo: [String: String] = [:]
    var registerManager: RegisterManager?
    
    @IBOutlet weak var errorMasageLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerManager = RegisterManager()
    }
    

    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let id = idTextField.text
        
        
        if let pw = pwTextField.text {
            if pw.validatePassword() {
                registerManager!.verifyEmail(key: "id", value: id!)
                if registerManager!.checkedEmail!{
                    let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "OptionViewController") as! OptionViewController
                    nextVC.userInfo = userInfo
                    nextVC.userInfo["userId"] = id
                    nextVC.userInfo["userPw"] = pwTextField.text
                    self.navigationController?.pushViewController(nextVC, animated: true)
                } else {
                    errorMasageLabel.text = "이미 존재하는 아이디입니다."
                    errorMasageLabel.isHidden = false
                    idTextField.layer.borderColor = UIColor.red.cgColor
                    idTextField.layer.borderWidth = 1
                    idTextField.layer.cornerRadius = 5
                }
            } else {
                errorMasageLabel.text = "비밀번호는 특수문자 포함 10자리 이상 입력하셔야 합니다."
                errorMasageLabel.isHidden = false
                pwTextField.layer.borderColor = UIColor.red.cgColor
                pwTextField.layer.borderWidth = 1
                pwTextField.layer.cornerRadius = 5
            }
        }
        
        
        
        
        

    }
}
