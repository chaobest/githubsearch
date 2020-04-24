//
//  ResultTableViewCell.swift
//  GithubSearch
//
//  Created by Chao Wang on 4/17/20.
//  Copyright © 2020 Chao Wang. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var repoNum: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        imgV.image = nil
        username.text = nil
        repoNum.text = nil
    }
    
    var viewModel: ResultCellViewModel? {
        didSet {
            username.text = viewModel?.user.name
            viewModel?.updateImage = { image in
                DispatchQueue.main.async {
                    self.imgV.image = image
                }
            }
            viewModel?.updateRepoCount = { count in
                DispatchQueue.main.async {
                    self.repoNum.text = "Repo: \(count)"
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        username.text = "Username"
        imgV.image = UIImage(named: "placeholder")
        repoNum.text = "Repo"
    }
}
