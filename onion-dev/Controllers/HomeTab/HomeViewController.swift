//
//  HomeViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/14.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController {

    var collectionItems = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    func setCollectionItems(){
        collectionItems = [
            "Apple",
            "Samsung",
            "Lg",
            "Sky",
            "MicroSoft",
            "Amazone",
            "Netflix",
            "etc..."
        ]
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! HomeCollectionViewCell
        //  Configure the Cell
        cell.CellLabel.text = collectionItems[indexPath.row]
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
