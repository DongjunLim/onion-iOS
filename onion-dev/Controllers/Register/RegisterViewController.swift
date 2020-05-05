//
//  RegisterViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/03/22.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

extension String {
    func validateEmail() -> Bool {
        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        let predicate = NSPredicate(format:"SELF MATCHES %@",emailRegEx)
        return predicate.evaluate(with: self)
    }
    func validatePassword() -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{10,16}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: self)
    }
}


class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var errorMassage: UILabel!
    var user: User? = nil
    @IBOutlet weak var temp: UITabBar!
    var registerManager: RegisterManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerManager = RegisterManager()
        
        nextButton.layer.borderColor = UIColor.black.cgColor
        nextButton.layer.borderWidth = 1
        nextButton.layer.cornerRadius = 5
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let email = emailField.text!
        if email.validateEmail() {
            registerManager!.verifyEmail(value: email) { completion in
                if completion == 202{
                    DispatchQueue.main.async{
                        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "InputAccountViewController") as! InputAccountViewController
                        self.user = User(email: String(email))
                        nextVC.user = self.user
                        
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                } else{
                    DispatchQueue.main.async{
                        self.errorMassage.text = "이미 존재하는 이메일입니다."
                        self.errorMassage.isHidden = false
                        self.emailField.layer.borderColor = UIColor.red.cgColor
                        self.emailField.layer.borderWidth = 1
                        self.emailField.layer.cornerRadius = 5
                    }
                }
            }
        } else {
            errorMassage.text = "올바른 이메일 주소를 입력하세요."
            errorMassage.isHidden = false
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
