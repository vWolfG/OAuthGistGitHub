//
//  GistsViewModel.swift
//  GistApp
//
//  Created by User on 16/08/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper

// A class for GistsViewModel
class GistsViewModel {
    
    private var gists = [Gist]()
    private let keychain = KeychainManager.sharedKeychainWrapper
    func loadGists(completion: @escaping ([Gist]) -> Void){
        guard let url = URL(string: Constans.url) else {return}
        let headers = ["Authorization":"token \(keychain.string(forKey: "access_token") ?? "")"]
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseData { (data) in
            switch data.result {
            case .success(let value):
                do {
                    self.gists = try JSONDecoder().decode([Gist].self, from: value)
                    completion(self.gists)
                } catch let error {
                    print("Gists uploading error \(error)")
                }
            case .failure(let err):
                print("Gists uploading error \(err)")
            }
        }
    }
    
    
}
