//
//  User.swift
//  GithubSearch
//
//  Created by Chao Wang on 4/18/20.
//  Copyright © 2020 Chao Wang. All rights reserved.
//

import Foundation
import UIKit
struct GitUsers: Codable {
    var items: [GitUser]
}

struct GitUser: Codable {
    var login: String
    var avatar_url: String
    var url: String
    var repos_url: String
}

struct UserToDisplay {
    var name: String?
    var avatar: UIImage?
    var detial: UserDetail?
    var repos: [GitRepo]?
}

struct UserDetail: Codable {
    var login: String?
    var email: String?
    var location: String?
    var created_at: String?
    var bio: String?
    var following: Int?
    var followers: Int?
    var public_repos: Int?
}
