//
//  OAuthNetworkData.swift
//  GistApp
//
//  Created by User on 15/08/2019.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

// A class for realizing network functions
class OAuthNetwork {
    
    public var code: String?
    private let keychain = KeychainManager.sharedKeychainWrapper
    public var codeGetRequest: URLRequest? {
        guard var urlComponents = URLComponents(string: Constans.urlOAuthCode) else {return nil}
        urlComponents.queryItems = [
            
            URLQueryItem(name: "client_id", value: "\(Constans.client_id)"),
            URLQueryItem(name: "scope", value: "gist"),
            URLQueryItem(name: "redirect_uri", value: "\(Constans.sheme)://host")
        ]
        guard let url = urlComponents.url else {return nil}
        print(url)
        return URLRequest(url: url)
    }
    
    private var tokenPostUrl: URL? {
        guard var urlComponents = URLComponents(string: Constans.urlOAuthToken) else {return nil}
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "\(Constans.client_id)"),
            URLQueryItem(name: "client_secret", value: "\(Constans.client_secret)"),
            URLQueryItem(name: "code", value: "\(code ?? "")"),
            URLQueryItem(name: "redirect_uri", value: "\(Constans.sheme)://host")
        ]
        guard let url = urlComponents.url else {return nil}
        return url
    }

    public func getToken(completion: @escaping  () -> Void ){
        guard let url  = self.tokenPostUrl else {return}
        print(url)
        let headers = ["Accept":"application/json"]
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseData { (data) in
            switch data.result{
            case .success( let value):
                do {
                    let jsonResponse = try JSONDecoder().decode(AccessToken.self, from: value)
                    self.keychain.set(jsonResponse.accessToken ?? "", forKey: "access_token")
                    completion()
                } catch let err {
                    print("Data error \(err)")
                }
                
            case .failure(let err):
                print("Error: \(err)")
            }
        }
    }
    
    
    public func addGist(name: String, content: String, completion: @escaping  (_ info: String) -> Void) {
        guard let url = URL(string: Constans.url) else {return}
        let parametrs = ["files": [name: ["content": content]] ]
        let headers = ["Content-Type":"application/json", "Authorization": "token \(keychain.string(forKey: "access_token") ?? "")"]
        Alamofire.request(url, method: .post, parameters: parametrs, encoding: JSONEncoding.default, headers: headers).validate().responseData { (data) in
            switch data.result {
            case .success(let _):
                //print("Success")
                completion("Success")
            case .failure(let err):
                completion("Post request is failed: \(err)")
            }
        }
    }
}
