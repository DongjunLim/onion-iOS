//
//  EditProfileViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/06/16.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit
import Alamofire
import KeychainSwift

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var profileImage: UIImage? = nil
    let picker = UIImagePickerController()
    
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var address1Field: UITextField!
    @IBOutlet weak var address2Field: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var instagramUrlField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.picker.sourceType = .photoLibrary // 방식 선택. 앨범에서 가져오는걸로 선택.
        self.picker.allowsEditing = false // 수정가능하게 할지 선택. 하지만 false
        self.picker.delegate = self // picker delegate
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let nickname = UserDefaults.standard.value(forKey: "userNickname") else { return }
        guard let age = UserDefaults.standard.value(forKey: "userAge") else { return }
        guard let height = UserDefaults.standard.value(forKey: "userHeight") else { return }
        guard let address1 = UserDefaults.standard.value(forKey: "userAddress1") else { return }
        guard let address2 = UserDefaults.standard.value(forKey: "userAddress2") else { return }
        guard let instagramUrl = UserDefaults.standard.value(forKey: "userInstagramUrl") else { return }
        guard let profilePhotoUrl = UserDefaults.standard.value(forKey: "userProfilePhotoUrl") else { return }
        
        FeedManager.getFeedImage(fileUrl: String(describing: profilePhotoUrl)) { result in
            self.profileImageView.image = result
            self.profileImageView.layer.cornerRadius =  self.profileImageView.frame.height / 2
        }
        
        self.heightField.text = String(describing: height)
        self.nameField.text = String(describing: nickname)
        self.ageField.text = String(describing: age)
        self.address1Field.text = String(describing: address1)
        self.address2Field.text = String(describing: address2)
        self.instagramUrlField.text = String(describing: instagramUrl)

    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func summitButtonPressed(_ sender: UIButton) {
        UserDefaults.standard.set(self.nameField.text, forKey: "userNickname")
        UserDefaults.standard.set(self.ageField.text, forKey: "userAge")
        UserDefaults.standard.set(self.heightField.text, forKey: "userHeight")
        UserDefaults.standard.set(self.address1Field.text, forKey: "userAddress1")
        UserDefaults.standard.set(self.address2Field.text, forKey: "userAddress2")
        UserDefaults.standard.set(self.instagramUrlField.text, forKey: "userInstagramUrl")
        UserManager.updateProfile() { statusCode in
            if statusCode == 200 {
                return
            } else {
                return
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func goToLibraryButtonPressed(_ sender: UIButton) {
        present(picker, animated: false, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        self.profileImageView.image = selectedImage!
        self.uploadImageFile(image: selectedImage!) { (statusCode) in
            if statusCode == 201 {
                return
            } else {
                return
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController {
    // 키보드말고 다른곳을 눌렀을때 키보드가 내려가게 하는 함수
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func uploadImageFile(image: UIImage, completion: @escaping (Int)->Void){
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
                         to: "\(Server.url)/profile/photo",
                         headers: ["authorization": token!],
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.validate()
                                upload.responseJSON { response in
                                    print(response.result.value)
                                    let decoder = JSONDecoder()
                                    do{
                                        completion(201)
                                    }catch{
                                        print("DECODE ERROR!")
                                    }
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                completion(202)
                            }
            }
        )
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

