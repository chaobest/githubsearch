//
//  SecondPageViewModel.swift
//  GithubSearch
//
//  Created by Chao Wang on 4/16/20.
//  Copyright © 2020 Chao Wang. All rights reserved.
//

import Foundation

class SecondPageViewModel {
    var title = "GitHub Search"
    var user: UserToDisplay?
    private var apiHandler = APIHandler.shared
    var updateRepos: ((Bool) -> Void)?
    var repos: [GitRepo] {
        didSet {
            self.updateRepos?(true)
        }
    }
    
    init(user: UserToDisplay? = nil) {
        self.user = user
        self.repos = []
    }
    
    func getRepos(_ user: GitUser) {
        apiHandler.getRepos(user.repos_url) { (result) in
            switch result {
            case .success(let repos):
                self.user?.repos = repos
                self.repos = repos
            case .failure(_):
                break
            }
        }
    }
    
    func searchRepo(_ text: String) {
        if text.isEmpty {
            repos = user?.repos ?? []
            return
        }
        var temp: [GitRepo] = []
        user?.repos?.forEach({ (repo) in
            if repo.name.uppercased().contains(text.uppercased()) {
                temp.append(repo)
            }
        })
        repos = temp
    }
}
