//
//  ViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/03/21.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
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



