//
//  TestViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/30.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit
import Alamofire

struct Feed: Codable {
    let feedList: [FeedList]
}

// MARK: - FeedList
struct FeedList: Codable {
    let feedID: String
    let hashTag: [String]
    let profileURL, profilePhotoURL, authorNickname, content: String
    let likeCount: Int
    let isLike, isFollow: Bool
    
    enum CodingKeys: String, CodingKey {
        case feedID = "feedId"
        case hashTag
        case profileURL = "profileUrl"
        case profilePhotoURL = "profilePhotoUrl"
        case authorNickname, content, likeCount, isLike, isFollow
    }
}



class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func testButtonPressed(_ sender: UIButton) {
        guard let url = URL(string: "http://127.0.0.1:3000/feed/test?") else { return }
        Alamofire.request(url,method: .get)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing:response.result.error))")
                    return }
                
                guard let jsonData = response.data as? Data else { return }
                
                do{
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(Feed.self, from: jsonData)
                    print(result.feedList[1].authorNickname)
                } catch {
                    print(error.localizedDescription)
                }
                
                guard let value = response.result.value as? [String : Any] else{
                    print("에러")
                    return
                }
                return
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
}
