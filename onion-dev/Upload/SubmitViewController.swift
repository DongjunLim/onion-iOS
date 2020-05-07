//
//  SummitViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/29.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit
import Alamofire
import KeychainSwift

struct file: Decodable{
    let filename: String
}

class SubmitViewController: UIViewController {
    
    var feedImage: UIImage!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var hashTagView: UIView!
    @IBOutlet weak var userGenderView: UIView!
    @IBOutlet weak var userHeightView: UIView!
    @IBOutlet weak var userAgeView: UIView!
    @IBOutlet weak var hashTagTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var userHeight: UILabel!
    @IBOutlet weak var userGenderLabel: UILabel!
    @IBOutlet weak var userAgeLabel: UILabel!
    
    @IBOutlet weak var selectCategoryView: UIView!
    
    @IBOutlet weak var Category1Button: UIButton!
    @IBOutlet weak var Category2Button: UIButton!
    @IBOutlet weak var Category3Button: UIButton!
    @IBOutlet weak var Category4Button: UIButton!
    @IBOutlet weak var Category5Button: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBOutlet weak var lock: UIView!
    var mainCategoryList: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedImageView.image = self.feedImage
        setBorderLayout()
        setUserInfo()
        selectCategoryView.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func setBorderLayout(){
        lock.layer.opacity = 0.5
        lock.isHidden = true
        self.setSubViewLayout(contentView)
        self.setSubViewLayout(hashTagView)
        self.setSubViewLayout(userAgeView)
        self.setSubViewLayout(userHeightView)
        self.setSubViewLayout(userGenderView)
        
        selectCategoryView.layer.borderColor = UIColor.orange.cgColor
        selectCategoryView.layer.borderWidth = 2
        selectCategoryView.layer.cornerRadius = 10
        
        self.setCategoryButtonLayout(Category1Button)
        self.setCategoryButtonLayout(Category2Button)
        self.setCategoryButtonLayout(Category3Button)
        self.setCategoryButtonLayout(Category4Button)
        self.setCategoryButtonLayout(Category5Button)
        
        submitButton.layer.cornerRadius = 5
        uploadButton.backgroundColor = UIColor.orange
        uploadButton.titleLabel?.text = "확인"
        uploadButton.layer.cornerRadius = 5
    }
    
    func setUserInfo(){
        self.userHeight.text = UserDefaults.standard.string(forKey: "userHeight")
        self.userAgeLabel.text = UserDefaults.standard.string(forKey: "userAge")
        self.userGenderLabel.text = UserDefaults.standard.string(forKey: "userGender")
    }
    
    func updateCategoryList(categoryName: String){
        if mainCategoryList.contains(categoryName){
            guard let index = mainCategoryList.firstIndex(of: categoryName) else { return  }
            mainCategoryList.remove(at: index)
        } else{
            self.mainCategoryList.append(categoryName)
        }
    }
    
    @IBAction func category1ButtonPressed(_ sender: UIButton) {
        changeCategoryButtonUI(sender)
        guard let categoryName = sender.titleLabel?.text else { return }
        self.updateCategoryList(categoryName: categoryName)

    }
    
    @IBAction func category2ButtonPressed(_ sender: UIButton) {
        changeCategoryButtonUI(sender)
        guard let categoryName = sender.titleLabel?.text else { return }
        self.updateCategoryList(categoryName: categoryName)
        
    }
    
    @IBAction func category3ButtonPressed(_ sender: UIButton) {
        changeCategoryButtonUI(sender)
        guard let categoryName = sender.titleLabel?.text else { return }
        self.updateCategoryList(categoryName: categoryName)
        
    }
    
    @IBAction func category4ButtonPressed(_ sender: UIButton) {
        changeCategoryButtonUI(sender)
        guard let categoryName = sender.titleLabel?.text else { return }
        self.updateCategoryList(categoryName: categoryName)
        
    }
    
    @IBAction func category5ButtonPressed(_ sender: UIButton) {
        changeCategoryButtonUI(sender)
        guard let categoryName = sender.titleLabel?.text else { return }
        self.updateCategoryList(categoryName: categoryName)
        
    }
    
    func setCategoryButtonLayout(_ sender: UIButton){
        sender.layer.borderWidth = 2
        sender.layer.cornerRadius = 5
        sender.backgroundColor = UIColor.white
        sender.layer.borderColor = UIColor.orange.cgColor
        sender.setTitleColor(.black , for: .normal)
    }
    
    func changeCategoryButtonUI(_ sender: UIButton){
        if sender.backgroundColor == UIColor.white{
            sender.backgroundColor = UIColor.orange
            sender.setTitleColor(.white , for: .normal)
        } else{
            self.setCategoryButtonLayout(sender)
        }
    }
    
    func setSubViewLayout(_ sender: UIView){
        sender.layer.borderColor = UIColor.lightGray.cgColor
        sender.layer.borderWidth = 1
        sender.layer.cornerRadius = 5
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
//        guard let image = feedImageView.image else {
//            //이미지 파일 없을때 예외처리 코드
//            return }
//
        lock.isHidden = false
        // uploadImageFile(image: image)
        selectCategoryView.isHidden = false;

        //        guard let content = contentTextView.text else {
        //            //본문 없을때 예외처리 코드
        //            return
        //        }
    }
    @IBAction func uploadButtonPressed(_ sender: UIButton) {
        // 1. 설정한 카테고리로 해서 서버에 데이터 전송
        // 2. 피드 디테일 화면으로 이동
    }
    func uploadImageFile(image: UIImage){
        let token = KeychainSwift().get("AccessToken")
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData,
                                     withName: "file",
                                     fileName: "img.jpg",
                                     mimeType: "image/jpeg")
        },
                         to: "\(Server.url)/feed/file",
                         headers: ["authorization": token!],
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.validate()
                                upload.responseJSON { response in
                                    let decoder = JSONDecoder()
                                    do{
                                        let filename = try decoder.decode(file.self, from: response.data!)
                                        print(filename)
                                        self.uploadContent(content: filename.filename, hashTag: [""])
                                        
                                    }catch{
                                        print("DECODE ERROR!")
                                    }
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                            }
            }
        )
    }
    
    func uploadContent(content: String, hashTag: [String]){
        guard let url = URL(string: "\(Server.url)/feed/") else{
            print("URL setting error")
            return
        }
        
        
        Alamofire.request(url,
                          method: .post,
                          parameters: ["feedContent":content,"hashTag": ["hashTag1","hashTag2"],"additionalInfo":["height":self.userHeight.text,"gender":self.userGenderLabel.text,"age":self.userAgeLabel.text]])
        .validate()
            .responseJSON { response in
                guard let statusCode = response.response?.statusCode else {
                  print("Error while fetching remote rooms: \(String(describing:response.result.error))")
                  return
                }
                print(statusCode)
        }
    }
}
