//
//  RegisterManager.swift
//  onion-dev
//
//  Created by 임동준 on 2020/03/23.
//  Copyright © 2020 lacuna. All rights reserved.
//

import Foundation

class RegisterManager {
    var checkedEmail: Bool?
    let semaphore: DispatchSemaphore?
    init(){
        self.checkedEmail = false
        self.semaphore = DispatchSemaphore(value: 0)
        return
    }
    
    
    func verifyEmail(key: String, value: String) -> Void{
        
        if let url = URL(string: "http://127.0.0.1:3000/account/check/?\(String(key))=\(String(value))") {
            print(url)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data,response,error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString!)
                    guard let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode) else { return }
                    if httpResponse.statusCode == 204 {
                        self.checkedEmail = true
                    } else {
                        self.checkedEmail = false
                    }
                }
                self.semaphore!.signal()
            }
            task.resume()
            self.semaphore!.wait()
        }
        return
    }
    
    func join(email: String, id: String, pw: String){
        if let url = URL(string: "http://127.0.0.1:3000/account/register/"){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                
            }
        }
    }
}
