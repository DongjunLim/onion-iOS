//
//  Feed.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/30.
//  Copyright © 2020 lacuna. All rights reserved.
//

import Foundation
import Alamofire
import KeychainSwift

struct FeedList: Codable {
    let feedList: [Feed]
}

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

// MARK: - ReplyList
struct ReplyList: Codable {
    let feedReplyList: [FeedReplyList]

    enum CodingKeys: String, CodingKey {
        case feedReplyList = "feed_reply_list"
    }
}

// MARK: - FeedReplyList
struct FeedReplyList: Codable {
    let createdAt, id, userNickname, replyContent: String

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id = "_id"
        case userNickname, replyContent
    }
}





class FeedManager{
    var feedList: Feed?
    
    func getRelativeFeedList(feedId: String, completion: @escaping (FeedList) -> Void){
        guard let token = KeychainSwift().get("AccessToken") else {
            DispatchQueue.main.async {
                // 로그인화면으로 이동
            }
            return
        }
        let header: HTTPHeaders = ["authorization": token]
        guard let url = URL(string: "\(Server.url)/feed/thumbnail/relative?") else {
            // URL 생성 안될경우 에러 핸들링
            return
        }
        
        Alamofire.request(url,method: .get,parameters: ["feedId":feedId],headers: header)
        .validate()
            .responseJSON{ response in
                guard response.result.isSuccess else {
                    // 통신 에러시
                    print("Error while fetching remote rooms: \(String(describing:response.result.error))")
                    return
                }
                
                // 데이터가 없을 경우
                guard let jsonData = response.data else {
                    print("실패")
                    return
                }
                
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
    
    
    func getFeedList(completion: @escaping (FeedList)-> Void){
        let token = KeychainSwift().get("AccessToken")
        let headers: HTTPHeaders = ["authorization": token!]
        guard let url = URL(string: "\(Server.url)/feed/test?") else { return }
        Alamofire.request(url,method: .get,headers: headers)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing:response.result.error))")
                    return }
                
                guard let jsonData = response.data else {
                    print("실패")
                    return }
                
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
    func addReply(feedId: String, content: String, completion: @escaping (Int)->Void){
        let token = KeychainSwift().get("AccessToken")
        let headers: HTTPHeaders = ["authorization": token!]
        guard let url = URL(string: "\(Server.url)/feed/reply?") else { return }
        Alamofire.request(url, method: .post, parameters: ["replyContent":content,"feedId":feedId], headers: headers)
        .validate()
            .responseJSON { response in
                let statusCode = response.response?.statusCode
                completion(statusCode!)
        }
    }
    
    func getReplyList(feedId: String, completion: @escaping (ReplyList)-> Void){
        let token = KeychainSwift().get("AccessToken")
        let headers: HTTPHeaders = ["authorization": token!]
        guard let url = URL(string: "\(Server.url)/feed/reply?") else { return }
        Alamofire.request(url, method: .get, parameters: ["feedId":feedId], headers: headers)
        .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing:response.result.error))")
                    return }
                guard let jsonData = response.data else {
                    print("실패")
                    return }
                
                do{
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(ReplyList.self, from: jsonData)
                    completion(result);
                } catch {
                    print(error.localizedDescription)
                }
                return
                
        }

    }
    
    func getHomeFeedList(completion: @escaping (FeedList)-> Void){
        let token = KeychainSwift().get("AccessToken")
        let headers: HTTPHeaders = ["authorization": token!]
        guard let url = URL(string: "\(Server.url)/feed/thumbnail/personal?") else { return }
        Alamofire.request(url,method: .get,headers: headers)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing:response.result.error))")
                    return }
                print(response.result.value)
                
                guard let jsonData = response.data else {
                    print("실패")
                    return }
                
                
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
    
    func getTimelineFeedList(completion: @escaping (FeedList)-> Void){
        let token = KeychainSwift().get("AccessToken")
        let headers: HTTPHeaders = ["authorization": token!]
        guard let url = URL(string: "\(Server.url)/feed/thumbnail/follower?") else { return }
        Alamofire.request(url,method: .get,headers: headers)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing:response.result.error))")
                    return }
                
                guard let jsonData = response.data else {
                    print("실패")
                    return }
                
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
        let requestUrl = "https://onionphotostorage.s3.ap-northeast-2.amazonaws.com/\(fileUrl)"
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



