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
    var user: User? = nil
    
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
                registerManager!.verifyNickname(value: String(id!)) { completion in
                    if completion == 202{
                        DispatchQueue.main.async {
                            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "OptionViewController") as! OptionViewController
                            self.user?._userPassword = self.pwTextField.text
                            self.user?._userId = self.idTextField.text
                            nextVC.user = self.user
                            
                            self.navigationController?.pushViewController(nextVC, animated: true)
                        }
                    }else{
                        DispatchQueue.main.async{
                            self.errorMasageLabel.text = "이미 존재하는 아이디입니다."
                            self.errorMasageLabel.isHidden = false
                            self.idTextField.layer.borderColor = UIColor.red.cgColor
                            self.idTextField.layer.borderWidth = 1
                            self.idTextField.layer.cornerRadius = 5
                        }
                    }
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
