//
//  ProductDetailViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/05/17.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit
import WebKit

class ProductDetailViewController: UIViewController, WKNavigationDelegate{

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet var sampleView: WKWebView!
    var webUrl: String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUrl()
        // Do any additional setup after loading the view.
    }
    
    func loadUrl(){
        let url = URL(string: self.webUrl!)
        let request = URLRequest(url: url!)
        self.sampleView.load(request)
        self.sampleView.navigationDelegate = self
        self.sampleView.layer.borderWidth = 1
        self.sampleView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
