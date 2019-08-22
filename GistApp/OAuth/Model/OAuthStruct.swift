//
//  OAuthModel.swift
//  GistApp
//
//  Created by User on 15/08/2019.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

// A struc for AccessToken
struct AccessToken: Codable {
    let accessToken: String?
    let tokeType: String?
    let scopeString: String?
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokeType = "token_type"
        case scopeString = "scope"
    }
}
