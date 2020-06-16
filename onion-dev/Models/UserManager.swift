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

struct Profile: Codable {
    let numOfFollowUser, numOfFollower: Int
    let bookmarkList, bucketList: [String]
    let profilePhotoURL: String
    let userNickname: String

    enum CodingKeys: String, CodingKey {
        case numOfFollowUser, numOfFollower, bookmarkList, bucketList, userNickname
        case profilePhotoURL = "profilePhotoUrl"
    }
}



class UserManager{
    
    static func updateProfile(completion: @escaping (Int) -> (Void)){
        
        guard let nickname = UserDefaults.standard.value(forKey: "userNickname") else { return }
        guard let age = UserDefaults.standard.value(forKey: "userAge") else { return }
        guard let height = UserDefaults.standard.value(forKey: "userHeight") else { return }
        guard let address1 = UserDefaults.standard.value(forKey: "userAddress1") else { return }
        guard let address2 = UserDefaults.standard.value(forKey: "userAddress2") else { return }
        guard let instagramUrl = UserDefaults.standard.value(forKey: "userInstagramUrl") else { return }
    
        
        guard let token = KeychainSwift().get("AccessToken") else {
            DispatchQueue.main.async {
                
            }
            return
        }
        let header: HTTPHeaders = ["authorization": token]
        guard let url = URL(string: "\(Server.url)/user/profile/") else {
            // URL 생성 안될경우 에러 핸들링
            return
        }
        
        Alamofire.request(url, method: .put, parameters:["userNickname": nickname,
        "userAge": age,
        "userHeight": height,
        "userAddress1": address1,
        "userAddress2": address2,
        "userInstagramUrl": instagramUrl],headers: header)
        .validate()
            .responseJSON { response in
                let statusCode = response.response?.statusCode
                completion(statusCode!)

        }
        
    }
    
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
    
    static func getMyProfile(completion: @escaping (Profile)->(Void)){
        let token = KeychainSwift().get("AccessToken")
        let headers: HTTPHeaders = ["authorization": token!]
        guard let url = URL(string: "\(Server.url)/user/profile/my-profile?") else { return }
        
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
                    
                    let result = try decoder.decode(Profile.self, from: jsonData)
                    print("디코딩 성공")
                    completion(result)
                    
                    
                } catch {
                    print("디코딩 실패")
                    print(error.localizedDescription)
                }
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
                    UserDefaults.standard.set(result.userAddress[0], forKey: "userAddress1")
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



