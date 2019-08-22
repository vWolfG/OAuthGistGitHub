//
//  GistModel.swift
//  GistApp
//
//  Created by User on 08/08/2019.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

// A struct fot Gist
struct Gist: Decodable {
    let url: String
    let files: [String: GistFile]
    let created_at: String
    let owner: Owner
    let comments: Int
}
struct Owner: Decodable {
    let login: String
    
}
struct GistFile: Decodable {
    let filename: String
    let type: String
    let language: String?
    let raw_url: String
    
    
}

