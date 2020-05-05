//
//  OptionViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/03/23.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit
import KeychainSwift

class OptionViewController: UIViewController {
    var registerManager: RegisterManager?
    var userInfo: [String: String] = [:]
    var user: User? = nil
    lazy var heightPickerView: UIPickerView = {
    let picker = UIPickerView()
    picker.frame = CGRect(x: 0, y: self.view.bounds.height - 180, width: self.view.bounds.width, height: 180.0)
    picker.backgroundColor = .white
    picker.delegate = self
    picker.dataSource = self;
    return picker }()
    var heightPickerViewData: [Int] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerManager = RegisterManager()
        for i in 130...210{
            heightPickerViewData.append(i)
        }
        self.view.addSubview(self.heightPickerView)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        //옵션 유효성 검사
        guard let userEmail = self.user?._userEmail else { return }
        guard let userNickname = self.user?._userId else { return }
        guard let userPassword = self.user?._userPassword else { return }
        
        //네트워크 전송
        registerManager!.join(email: String(userEmail), id: String(userNickname), pw: String(userPassword)) { token in
            DispatchQueue.main.async {
                KeychainSwift().set(token, forKey: "AccessToken")
            }
        }
        
        //화면전환
        self.performSegue(withIdentifier: "goToFinishView", sender: self)
    }

}


extension OptionViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return heightPickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return String(heightPickerViewData[row]) }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("row: \(row)")
        print("value: \(heightPickerViewData[row])")
    }
    
    
    
}
