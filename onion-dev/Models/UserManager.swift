//
//  UserManager.swift
//  onion-dev
//
//  Created by 임동준 on 2020/03/23.
//  Copyright © 2020 lacuna. All rights reserved.
//

import Foundation
import Alamofire
import KeychainSwift

struct UserInfo: Codable {
    let userGender, userNickname: String
    let userAddress: [String]
    let userHeight: Double
    let userAge: Int
    let userInstagramURL, userProfilephotoURL: String

    enum CodingKeys: String, CodingKey {
        case userGender = "user_gender"
        case userNickname = "user_nickname"
        case userAddress = "user_address"
        case userHeight = "user_height"
        case userAge = "user_age"
        case userInstagramURL = "user_Instagram_url"
        case userProfilephotoURL = "user_profilephoto_url"
    }
}


class UserManager{
    
    static func follow(targetUserNickname: String, completion: @escaping (Int)->(Void)){
        guard let token = KeychainSwift().get("AccessToken") else {
            DispatchQueue.main.async {
                
            }
            return
        }
        let header: HTTPHeaders = ["authorization": token]
        guard let url = URL(string: "\(Server.url)/user/follow") else {
            // URL 생성 안될경우 에러 핸들링
            return
        }
        
        Alamofire.request(url,method: .post,parameters: ["targetNickname":targetUserNickname],headers:header)
            .validate()
            .responseJSON { response in
                let statusCode = response.response?.statusCode
                completion(statusCode!)
        }
    }
    
    static func unFollow(targetUserNickname: String, completion: @escaping (Int)->(Void)){
        guard let token = KeychainSwift().get("AccessToken") else {
            DispatchQueue.main.async {
                
            }
            return
        }
        let header: HTTPHeaders = ["authorization": token]
        guard let url = URL(string: "\(Server.url)/user/follow") else {
            // URL 생성 안될경우 에러 핸들링
            return
        }
        
        Alamofire.request(url,method: .delete,parameters: ["targetNickname":targetUserNickname],headers:header)
        .validate()
            .responseJSON { response in
                let statusCode = response.response?.statusCode
                print(statusCode)
                completion(statusCode!)
        }
    }
    
    static func requestUserInfo(){
        guard let token = KeychainSwift().get("AccessToken") else {
            DispatchQueue.main.async {
                // 로그인화면으로 이동
            }
            return
        }
        let header: HTTPHeaders = ["authorization": token]
        guard let url = URL(string: "\(Server.url)/user") else {
            // URL 생성 안될경우 에러 핸들링
            return
        }
        
        Alamofire.request(url,method: .get,headers: header)
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
                    let result = try decoder.decode(UserInfo.self, from: jsonData)
                    print("SUCCESS1")
                    UserDefaults.standard.set(result.userNickname, forKey: "userNickname")
                    UserDefaults.standard.set(result.userAge, forKey: "userAge")
                    UserDefaults.standard.set(result.userGender, forKey: "userGender")
                    UserDefaults.standard.set(result.userHeight, forKey: "userHeight")
                    UserDefaults.standard.set(result.userAddress[0], forKey: "userAddess1")
                    UserDefaults.standard.set(result.userAddress[1], forKey: "userAddress2")
                    UserDefaults.standard.set(result.userInstagramURL, forKey: "userInstagramUrl")
                    UserDefaults.standard.set(result.userProfilephotoURL, forKey: "userProfilePhotoUrl")

                    print("SUCCESS2")
                } catch {
                    print(error.localizedDescription)
                }
        }
    }
    
    
    
    
}



