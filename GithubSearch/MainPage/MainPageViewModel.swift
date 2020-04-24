//
//  MainPageViewModel.swift
//  GithubSearch
//
//  Created by Chao Wang on 4/16/20.
//  Copyright © 2020 Chao Wang. All rights reserved.
//

import Foundation

protocol MainPageViewModelProtocal: AnyObject {
    func updateUser(users: [GitUser])
    func displayAlert(message: String)
}

class MainPageViewModel {
    var title = "GitHub Searcher"
    var login: Bool = false
    var username: String = ""
    var users: [GitUser] = []
    private let apiHandler = APIHandler.shared
    var page = 0
    var updateUser: ((Bool) -> Void)?
    weak var delegate: MainPageViewModelProtocal?
    
    func getUsers(_ username: String) {
        if username.isEmpty {
            users = []
            self.delegate?.updateUser(users: users)
            return
        }
        apiHandler.getSearchUsers(username, page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                if self.page == 0 {
                    self.users = users
                } else {
                    self.users.append(contentsOf: users)
                }
                self.delegate?.updateUser(users: self.users)
            case .failure(let error):
                self.users = []
                self.delegate?.updateUser(users: self.users)
                self.delegate?.displayAlert(message: error.errorDescription ?? "")
            }
        }
    }
    
    func getUserName(_ index: Int) -> String {
        return users[index].login
    }
    
    func getNumOfRows() -> Int {
        return users.count
    }
}
