//
//  photoLibViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/05/04.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class photoLibViewController: UIViewController{
    let picker = UIImagePickerController()

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var testButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.sourceType = .photoLibrary // 방식 선택. 앨범에서 가져오는걸로 선택.
        self.picker.allowsEditing = false // 수정가능하게 할지 선택. 하지만 false
//        self.picker.delegate = self // picker delegate
        
        

        // Do any additional setup after loading the view.
    }
    @IBAction func testButtonPressed(_ sender: UIButton) {
        self.pickImage()
    }
    
    @objc func pickImage(){
        present(self.picker, animated: false, completion: nil)

    }
    



}
//
//extension photoLibViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//    {
//
//
//
//        picker.dismiss(animated: true) // 그리고 picker를 닫아준다.
//    }

    

