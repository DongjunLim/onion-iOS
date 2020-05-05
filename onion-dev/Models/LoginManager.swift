//
//  LoginManager.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/28.
//  Copyright © 2020 lacuna. All rights reserved.
//

import Foundation

struct AccessToken: Decodable {
    let token: String
}

class LoginManager{
    
    init(){
        return
    }
    
    func login(email: String, password: String, completion: @escaping (Int, String) -> Void){
        let urlComponents = URLComponents(string: "\(Server.url)/login?")!
        var request = URLRequest(url: urlComponents.url!)
        
        request.httpMethod = "GET"
        request.addValue(email, forHTTPHeaderField:"userEmail")
        request.addValue(password, forHTTPHeaderField: "userPassword")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200..<300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode,
                successRange.contains(statusCode) else {
                    completion(0,"error")
                    return
            }
            
            guard let resultData = data else {
                completion(0,"error")
                return
            }
            let decoder = JSONDecoder()
            do{
                let result = try decoder.decode(AccessToken.self, from: resultData)
                completion(statusCode, result.token)
            } catch{
                completion(statusCode,"")
            }
            
            return
        }
        dataTask.resume()
    }
    
    
    
}
