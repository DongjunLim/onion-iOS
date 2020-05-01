//
//  RegisterManager.swift
//  onion-dev
//
//  Created by 임동준 on 2020/03/23.
//  Copyright © 2020 lacuna. All rights reserved.
//

import Foundation

class RegisterManager {

    
    func verifyEmail (value: String, completion: @escaping (Int) -> Void){
        let session = URLSession(configuration: .default)
        var urlComponents = URLComponents(string: "http://172.30.1.27:3000/account/check-email?")!
        let emailQuery = URLQueryItem(name: "userEmail", value: value)
        urlComponents.queryItems?.append(emailQuery)
        
        let requestURL = urlComponents.url!
        
        let dataTask = session.dataTask(with: requestURL) { data, response, error in
            let successRange = 200..<300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode,
                successRange.contains(statusCode) else {
                    return
            }
            completion(statusCode)
            return
        }
        dataTask.resume()
    }
    
    func verifyNickname (value: String, completion: @escaping (Int) -> Void){
        let session = URLSession(configuration: .default)
        var urlComponents = URLComponents(string: "http://172.30.1.27:3000/account/check-nickname?")!
        let nicknameQuery = URLQueryItem(name: "userNickname", value: value)
        urlComponents.queryItems?.append(nicknameQuery)
        
        let requestURL = urlComponents.url!
        
        let dataTask = session.dataTask(with: requestURL) { data, response, error in
            let successRange = 200..<300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode,
                successRange.contains(statusCode) else {
                    return
            }
            completion(statusCode)
            return
        }
        dataTask.resume()
    }
    
    
    func join(email: String, id: String, pw: String, completion: @escaping (String) -> Void){
        
        let urlComponents = URLComponents(string: "http://172.30.1.27:3000/account/register?")!
        let requestURL = urlComponents.url!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"

        let parameters: [String: Any] = [
            "userEmail": email,
            "userNickname": id,
            "userPassword": pw
        ]
        request.httpBody = parameters.percentEncoded()
        
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200..<300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode,
                successRange.contains(statusCode) else {
                    return
            }
            guard let resultData = data else {
                completion("error")
                return
            }
            if statusCode == 201{
                let decoder = JSONDecoder()
                do{
                    let result = try decoder.decode(AccessToken.self, from: resultData)
                    completion(result.token)
                    print("DONE")
                } catch{
                    completion("")
                }
            }
        }
        dataTask.resume()
        
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
