//
//  EndPoint.swift
//  GithubSearch
//
//  Created by Chao Wang on 4/17/20.
//  Copyright © 2020 Chao Wang. All rights reserved.
//

import Foundation

let baseURL = "https://api.github.com"
enum EndPoint: String {
    case logIn = "/user"
    case users = "/search/users?q="
}
