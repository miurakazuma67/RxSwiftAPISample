//
//  ViewController.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/04.
//

import UIKit

final class LoginViewController: UIViewController {

    @IBOutlet private weak var mailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registerButtonTapped(_ sender: Any) {
        Router.shared.showRegister(from: self)
    }

}

