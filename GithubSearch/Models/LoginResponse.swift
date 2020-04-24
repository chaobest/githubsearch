//
//  LoginResponse.swift
//  GithubSearch
//
//  Created by Chao Wang on 4/17/20.
//  Copyright © 2020 Chao Wang. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    var message: String
    var documentation_url: String?
    var errors: [ErrorMsg]?
}

struct ErrorMsg: Codable {
    var resource: String
    var field: String
    var code: String
}
