//
//  MainPageViewController.swift
//  GithubSearch
//
//  Created by Chao Wang on 4/16/20.
//  Copyright © 2020 Chao Wang. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultTableView: UITableView!
    var viewModel: MainPageViewModel!
    var apiHandler = APIHandler.shared
    convenience init(viewModel: MainPageViewModel) {
        self.init(nibName: "MainPageViewController", bundle: Bundle(for: MainPageViewController.self))
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        searchBar.backgroundImage = UIImage()
        if viewModel.login {
            userLabel.text = "Welcome \(viewModel.username)"
        } else {
            userLabel.isHidden = true
            let backToRootVCButton = UIBarButtonItem.init(title: "Back", style: .plain, target: self, action: #selector(backToRootVCAction))
            self.navigationItem.setLeftBarButton(backToRootVCButton, animated: false)
        }
        viewModel.delegate = self
        resultTableView.delegate = self
        resultTableView.dataSource = self
        searchBar.delegate = self
        resultTableView.register(UINib(nibName: "ResultTableViewCell", bundle: Bundle(for: ResultTableViewCell.self)), forCellReuseIdentifier: "ResultTableViewCell")
    }
    
    @objc func backToRootVCAction(_ sender: UIBarButtonItem) {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        UIApplication.shared.windows.first?.rootViewController = loginVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

extension MainPageViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.page = 0
        viewModel.getUsers(searchBar.text ?? "")
    }
}

extension MainPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath) as? ResultTableViewCell else {
            return UITableViewCell() }
        if indexPath.row < viewModel.users.count {
            let cellVM = ResultCellViewModel(viewModel.users[indexPath.row])
            cell.viewModel = cellVM
        } else {
            cell.viewModel = ResultCellViewModel(nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ResultTableViewCell else { return }
        let secondVM = SecondPageViewModel(user: cell.viewModel?.user)
        secondVM.getRepos(viewModel.users[indexPath.row])
        let secondVC = SecondPageViewController(viewModel: secondVM)
        navigationController?.pushViewController(secondVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height {
            viewModel.page += 1
            viewModel.getUsers(searchBar.text ?? "")
        }
    }
}

extension MainPageViewController: MainPageViewModelProtocal {
    func updateUser(users: [GitUser]) {
        DispatchQueue.main.async {
            self.resultTableView.reloadData()
        }
    }
    
    func displayAlert(message: String) {
        Helper.showAlert(controller: self, title: "Error", message: message)
    }
}
