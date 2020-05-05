//
//  SummitViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/29.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit
import Alamofire

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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedImageView.image = self.feedImage
        setBorderLayout()
        setUserInfo()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func setBorderLayout(){
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 5
        
        hashTagView.layer.borderColor = UIColor.black.cgColor
        hashTagView.layer.borderWidth = 1
        hashTagView.layer.cornerRadius = 5
        
        userAgeView.layer.borderColor = UIColor.black.cgColor
        userAgeView.layer.borderWidth = 1
        userAgeView.layer.cornerRadius = 5
        
        userHeightView.layer.borderColor = UIColor.black.cgColor
        userHeightView.layer.borderWidth = 1
        userHeightView.layer.cornerRadius = 5
        
        userGenderView.layer.borderColor = UIColor.black.cgColor
        userGenderView.layer.borderWidth = 1
        userGenderView.layer.cornerRadius = 5
        
        submitButton.layer.cornerRadius = 5
    }
    
    func setUserInfo(){
        self.userHeight.text = "180"
        self.userAgeLabel.text = "30대"
        self.userGenderLabel.text = "남성"
        
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        guard let image = feedImageView.image else {
            //이미지 파일 없을때 예외처리 코드
            return }
        
        uploadImageFile(image: image)
        
        //        guard let content = contentTextView.text else {
        //            //본문 없을때 예외처리 코드
        //            return
        //        }
        
        
    }
    func uploadImageFile(image: UIImage){
        let token = UserDefaults.standard.string(forKey: "token")
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData,
                                     withName: "happy",
                                     fileName: "img.jpg",
                                     mimeType: "image/jpeg")
        },
                         to: "\(Server.url)/feed/file",
                         headers: ["AccessToken": token!],
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




