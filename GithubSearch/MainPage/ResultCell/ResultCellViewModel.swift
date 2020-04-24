//
//  ResultCellViewModel.swift
//  GithubSearch
//
//  Created by Chao Wang on 4/17/20.
//  Copyright © 2020 Chao Wang. All rights reserved.
//

import Foundation
import UIKit

class ResultCellViewModel {
    var user: UserToDisplay = UserToDisplay()
    private var apiHandler = APIHandler.shared
    var updateRepoCount: ((Int) -> Void)?
    var updateImage: ((UIImage) -> Void)?
    
    init(_ gitUser: GitUser?) {
        guard let gitUser = gitUser else { return }
        self.user.name = gitUser.login
        getDetial(gitUser)
        getImage(gitUser)
    }
    
    func getImage(_ user: GitUser) {
        apiHandler.getImage(user.avatar_url) { (result) in
            switch result {
            case .success(let image):
                if let image = image as? UIImage {
                    self.user.avatar = image
                    self.updateImage?(image)
                }
            case .failure(_):
                break
            }
        }
    }
    
    func getDetial(_ user: GitUser) {
        apiHandler.getUserDetail(user.url) { (result) in
            switch result {
            case .success(let detial):
                self.user.detial = detial
                self.updateRepoCount?(detial.public_repos ?? 0)
            case .failure(_):
                break
            }
        }
    }
}
