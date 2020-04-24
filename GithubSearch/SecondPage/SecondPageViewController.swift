//
//  SecondPageViewController.swift
//  GithubSearch
//
//  Created by Chao Wang on 4/16/20.
//  Copyright © 2020 Chao Wang. All rights reserved.
//

import UIKit

class SecondPageViewController: UIViewController {
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var joinDate: UILabel!
    @IBOutlet weak var follower: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var repoTableView: UITableView!
    var viewModel: SecondPageViewModel!
    
    convenience init(viewModel: SecondPageViewModel) {
        self.init(nibName: "SecondPageViewController", bundle: Bundle(for: SecondPageViewController.self))
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgV.image = viewModel.user?.avatar
        username.text = "Username: \(viewModel.user?.name ?? "")"
        email.text = "Email: \(viewModel.user?.detial?.email ?? "")"
        location.text = "Location: \(viewModel.user?.detial?.location ?? "")"
        joinDate.text = "Join Date: \(viewModel.user?.detial?.created_at ?? "")"
        follower.text = "\(viewModel.user?.detial?.followers ?? 0) followers"
        following.text = "\(viewModel.user?.detial?.following ?? 0) following"
        bio.text = "\(viewModel.user?.detial?.bio ?? "")"
        repoTableView.register(UINib(nibName: "RepoTableViewCell", bundle: Bundle(for: RepoTableViewCell.self)), forCellReuseIdentifier: "RepoTableViewCell")
        repoTableView.delegate = self
        repoTableView.dataSource = self
        viewModel.updateRepos = { bool in
            DispatchQueue.main.async {
                self.repoTableView.reloadData()
            }
        }
        searchBar.delegate = self
    }
}

extension SecondPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepoTableViewCell", for: indexPath) as? RepoTableViewCell else { return UITableViewCell() }
        cell.repoName.text = viewModel.repos[indexPath.row].name
        cell.folks.text = "\(viewModel.repos[indexPath.row].forks_count ) Folks"
        cell.star.text = "\(viewModel.repos[indexPath.row].stargazers_count ) Starts"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension SecondPageViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchRepo(searchText)
    }
}
