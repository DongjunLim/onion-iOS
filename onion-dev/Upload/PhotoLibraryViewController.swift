//
//  PhotoLibraryViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/30.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class PhotoLibraryViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    let picker = UIImagePickerController()
    let selectedImageView: UIImageView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.sourceType = .photoLibrary // 방식 선택. 앨범에서 가져오는걸로 선택.
        self.picker.allowsEditing = true // 수정가능하게 할지 선택. 하지만 false
        self.picker.delegate = self // picker delegate
        
        // Do any additional setup after loading the view.
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage: UIImage? = nil
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage { // 수정된 이미지가 있을 경우
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage { // 오리지널 이미지가 있을 경우
            newImage = possibleImage
        }
        
        //        imageView.image = newImage // 받아온 이미지를 이미지 뷰에 넣어준다.
        
        picker.dismiss(animated: true) // 그리고 picker를 닫아준다.
    }
}
