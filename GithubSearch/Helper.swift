//
//  Helper.swift
//  GithubSearch
//
//  Created by Chao Wang on 4/17/20.
//  Copyright © 2020 Chao Wang. All rights reserved.
//

import Foundation
import UIKit

enum Helper {
    static internal func showAlert(controller: UIViewController, title: String = "", message: String = "") {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Cancel", style: .default)
        alertVC.addAction(alertAction)
        DispatchQueue.main.async {
            controller.present(alertVC, animated: true)
        }
    }
}
