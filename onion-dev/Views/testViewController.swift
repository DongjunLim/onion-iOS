//
//  testViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/05/05.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class testViewController: UIViewController ,UIPickerViewDataSource, UIPickerViewDelegate{

    @IBOutlet weak var testButton: UIButton!
    
    lazy var pickerView: UIPickerView = { // Generate UIPickerView.
        let picker = UIPickerView() // Specify the size.
        picker.frame = CGRect(x: 0, y: self.view.bounds.height - 180, width: self.view.bounds.width, height: 180.0) // Set the backgroundColor.
        picker.backgroundColor = .white // Set the delegate.
        picker.delegate = self // Set the dataSource.
        picker.dataSource = self;
        return picker }()

    @IBAction func testButtonPressed(_ sender: UIButton) {
        
        self.view.addSubview(self.pickerView)
    }
    var heightPickerViewData: [Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 130...210{
            heightPickerViewData.append(i)
        }
//        self.view.addSubview(self.pickerView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        dismiss(animated: true, completion: nil)
    }

}

