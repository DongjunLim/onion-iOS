//
//  ProductListViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/05/18.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController {
    var idx = 0
    let productList = [
    [
        "productName":"COS 라이트그린 면바지",
        "productPrice":"105,000",
        "productPhotoUrl":"https://image.thehyundai.com/static/3/9/5/00/A1/hnm40A1005934_02_0851241_001_001_1600.jpg",
        "productUrl":"https://www.cosstores.com/kr_krw/men/trousers/product.oversized-lightweight-trousers-grey.0851241001.html?slitmCd=40A1005934"
        ],
    [
        "productName":"SPAO 루즈핏 더블자켓",
        "productPrice":"32,000",
        "productPhotoUrl":"http://www.elandrs.com/upload/fckeditor/tempgoodsdesc/2020031583218830535.jpg",
        "productUrl":"http://spao.elandmall.com/goods/initGoodsDetail.action?goods_no=2002065017&vir_vend_no=VV16001887&sale_shop_divi_cd=11&disp_ctg_no=&sale_area_no=D1606000566&tr_yn=N&conts_dist_no=2002065017&conts_divi_cd=20&rel_no=2002065017&rel_divi_cd=10&brand_nm=%EC%8A%A4%ED%8C%8C%EC%98%A4&goods_nm=%EB%A3%A8%EC%A6%88%ED%95%8F+%EB%8D%94%EB%B8%94%EC%9E%90%EC%BC%93_SPJKA23M03&cust_sale_price=59900&ga_ctg_nm=%EB%B8%94%EB%A0%88%EC%9D%B4%EC%A0%80%2F%EC%9E%90%EC%BC%93&isComingSoonYn=N&isReservComingSoonYn=N&reserve_start_dtime=&dlp_list=&dlp_category=MEN%2F%EC%95%84%EC%9A%B0%ED%84%B0%2Fx"
        ],
    [
        "productName":"Nike Air Max 95-qs",
        "productPrice":"129,000",
        "productPhotoUrl":"https://static-breeze.nike.co.kr/kr/ko_kr/cmsstatic/product/CJ0589-001/8c081e1a-0daa-4740-b5d3-840dd43f81c4_primary.jpg?browse",
        "productUrl":"https://www.nike.com/kr/ko_kr/t/men/fw/nike-sportswear/CJ0589-001/frmc20/air-max-95-qs"
        ]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func getProductThumbnail(imageUrl: String, completion: @escaping (UIImage)->(Void)){
        let requestUrl = imageUrl
        guard let url = URL(string: requestUrl) else { return }
        do{
            let data = try Data(contentsOf: url)
            completion(UIImage(data: data)!)
        }catch let err{
            print("Error : \(err.localizedDescription)")
            return
        }
    }
}

extension ProductListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCollectionViewCell", for: indexPath) as? ProductListCollectionViewCell else {
            return UICollectionViewCell()
        }
        let iUrl = String(productList[idx]["productPhotoUrl"]!)
        cell.productName.text = String(productList[idx]["productName"]!)
        cell.productPrice.text = String(productList[idx]["productPrice"]!)
        cell.productUrl = String(productList[idx]["productUrl"]!)
        self.idx = (self.idx + 1) % 3
        self.getProductThumbnail(imageUrl: iUrl) {  result in
            cell.productImageView.image = result
        }
        
        
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let select = collectionView.cellForItem(at: indexPath) as! ProductListCollectionViewCell
        let productDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        productDetailVC.webUrl = select.productUrl!
        self.present(productDetailVC, animated: true, completion: nil)
    }
    
    
}
