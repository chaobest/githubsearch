//
//  Repo.swift
//  GithubSearch
//
//  Created by Chao Wang on 4/18/20.
//  Copyright © 2020 Chao Wang. All rights reserved.
//

import Foundation

struct GitRepo: Codable {
    var name: String
    var forks_count: Int
    var stargazers_count: Int
}
