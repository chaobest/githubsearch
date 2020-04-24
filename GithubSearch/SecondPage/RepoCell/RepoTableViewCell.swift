//
//  RepoTableViewCell.swift
//  GithubSearch
//
//  Created by Chao Wang on 4/19/20.
//  Copyright © 2020 Chao Wang. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var folks: UILabel!
    @IBOutlet weak var star: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
