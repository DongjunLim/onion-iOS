//
//  Feed.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/30.
//  Copyright © 2020 lacuna. All rights reserved.
//

import Foundation
import Alamofire

struct FeedList: Codable {
    let feedList: [Feed]
}

// MARK: - FeedList
struct Feed: Codable {
    let feedID: String
    let hashTag: [String]
    let profileURL, profilePhotoURL, authorNickname, content,photoUrl, feedThumbnailUrl: String
    let likeCount: Int
    let isLike, isFollow: Bool
    
    enum CodingKeys: String, CodingKey {
        case feedID = "feedId"
        case hashTag
        case profileURL = "profileUrl"
        case profilePhotoURL = "profilePhotoUrl"
        case photoUrl = "photoUrl"
        case feedThumbnailUrl = "feedThumbnailUrl"
        case authorNickname, content, likeCount, isLike, isFollow
    }
}

class FeedManager{
    var feedList: Feed?
    
    
    static func getFeedList(completion: @escaping (FeedList)-> Void){
        guard let url = URL(string: "http://127.0.0.1:3000/feed/test?") else { return }
        Alamofire.request(url,method: .get)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing:response.result.error))")
                    return }
                
                guard let jsonData = response.data else { return }
                
                do{
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(FeedList.self, from: jsonData)
                    completion(result);
                } catch {
                    print(error.localizedDescription)
                }
                return
        }
    }
    static func getFeedImage(fileUrl: String, completion: @escaping (UIImage)-> Void){
        guard let url = URL(string: fileUrl) else { return }
        
        do{
            let data = try Data(contentsOf: url)
            completion(UIImage(data: data)!)
            
        }catch let err{
            print("Error : \(err.localizedDescription)")
            return
        }
    }
    
}



