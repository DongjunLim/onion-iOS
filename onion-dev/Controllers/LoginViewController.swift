//
//  ViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/03/21.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit
import KeychainSwift

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    var loginmanager: LoginManager!
    @IBOutlet weak var errorMassageLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var blackEffectBackgroundImageView: UIImageView!
    @IBOutlet weak var LoginViewBackGroundImage: UIImageView!
    
    override func viewDidLoad() {
        KeychainSwift().clear()
        super.viewDidLoad()
        updateUI()
        self.hideKeyboardWhenTappedAround()
    }
    
    func updateUI(){
        LoginViewBackGroundImage.alpha = 0.8
        blackEffectBackgroundImageView.alpha = 0.5
        registerButton.layer.cornerRadius = 5
        emailTextField.alpha = 0.7
        pwTextField.alpha = 0.7
        registerButton.alpha = 0.7
        loginButton.alpha = 0.7
        loginButton.layer.cornerRadius = 5
        loginmanager = LoginManager()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let userEmail = emailTextField.text!
        let userPassword = pwTextField.text!
        view.endEditing(true)
        if !userEmail.validateEmail() {
            errorMassageLabel.text = "올바른 이메일주소를 입력하세요."
            errorMassageLabel.isHidden = false
            self.emailTextField.layer.borderColor = UIColor.red.cgColor
            self.emailTextField.layer.borderWidth = 1
            self.emailTextField.layer.cornerRadius = 5
            self.pwTextField.layer.borderColor = UIColor.black.cgColor
            
            return
        }
        
        if !userPassword.validatePassword() {
            errorMassageLabel.text = "비밀번호는 특수문자 포함 10자리 이상 입력하셔야 합니다."
            errorMassageLabel.isHidden = false
            self.pwTextField.layer.borderColor = UIColor.red.cgColor
            self.pwTextField.layer.borderWidth = 1
            self.pwTextField.layer.cornerRadius = 5
            self.emailTextField.layer.borderColor = UIColor.black.cgColor
            return
        }
        
        
        loginmanager.login(email: String(userEmail), password: String(userPassword)) { (statusCode, token) in
            if statusCode == 200 {
                DispatchQueue.main.async {
                    print(token)
                    KeychainSwift().set(token, forKey: "AccessToken")
                    UserManager.requestUserInfo()
                    self.moveHomeView()
                }
            } else{
                DispatchQueue.main.async {
                    self.errorMassageLabel.text = "계정정보가 일치하지 않습니다."
                    self.errorMassageLabel.isHidden = false
                    return
                }
            }
        }
        
        
    }
    func moveHomeView(){
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        self.performSegue(withIdentifier: "goToHomeViewSegue", sender: self)
    }
    
    
    
    @IBAction func RegisterButtonPressed(_ sender: UIButton) {
        let registerVC = RegisterViewController()
        registerVC.modalPresentationStyle = .fullScreen
        self.performSegue(withIdentifier: "goToRegisterNavigation", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "goToRegisterNavigation" {
            
        }
    }
}

extension LoginViewController {
    // 키보드말고 다른곳을 눌렀을때 키보드가 내려가게 하는 함수
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


