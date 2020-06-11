//
//  HistoryManager.swift
//  onion-dev
//
//  Created by 임동준 on 2020/06/11.
//  Copyright © 2020 lacuna. All rights reserved.
//

import Foundation
import KeychainSwift
import Alamofire


// MARK: - History
struct History: Codable {
    let userHistoryList: [UserHistoryList]

    enum CodingKeys: String, CodingKey {
        case userHistoryList = "user_history_list"
    }
}

// MARK: - UserHistoryList
struct UserHistoryList: Codable {
    let type: String
    let follower: String?
    let createdAt: Int
    let profileURL, feedID, writer, comment: String?
    let likeCount: Int?

    enum CodingKeys: String, CodingKey {
        case type, follower
        case createdAt = "created_at"
        case profileURL = "profileUrl"
        case feedID = "feedId"
        case writer, comment, likeCount
    }
}


class HistoryManager {
    
    static func getHistoryList(completion: @escaping (History) -> (Void)){
        let token = KeychainSwift().get("AccessToken")
        let headers: HTTPHeaders = ["authorization": token!]
        guard let url = URL(string: "\(Server.url)/history/list?") else { return }
        
        Alamofire.request(url, method: .get, headers: headers)
        .validate()
            .responseJSON { response in
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
                    let result = try decoder.decode(History.self, from: jsonData)
                    print("디코딩 성공")
                    completion(result)
                } catch {
                    print("디코딩 실패")
                    print(error.localizedDescription)
                }
        }
    }
}
