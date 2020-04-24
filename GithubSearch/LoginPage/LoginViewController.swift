//
//  LoginViewController.swift
//  GithubSearch
//
//  Created by Chao Wang on 4/17/20.
//  Copyright © 2020 Chao Wang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    var apiHandler: APIHandler?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiHandler = APIHandler.shared
        password.isSecureTextEntry = true
    }
    
    @IBAction func clickLogin(_ sender: Any) {
        guard let username = username.text, let password = password.text else { return }
        apiHandler?.makeLoginCall(username, password, completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    let mpViewModel = MainPageViewModel()
                    mpViewModel.login = true
                    mpViewModel.username = username
                    let mpVC = MainPageViewController(viewModel: mpViewModel)
                    let navigationVC = UINavigationController()
                    UIApplication.shared.windows.first?.rootViewController = navigationVC
                    navigationVC.pushViewController(mpVC, animated: true)
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                }
            case .failure(let error):
                Helper.showAlert(controller: self, title: "Error", message: error.errorDescription ?? "")
            }
        })
    }
    
    @IBAction func clickGuest(_ sender: Any) {
        let mpViewModel = MainPageViewModel()
        let mpVC = MainPageViewController(viewModel: mpViewModel)
        let navigationVC = UINavigationController()
        UIApplication.shared.windows.first?.rootViewController = navigationVC
        navigationVC.pushViewController(mpVC, animated: true)
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
