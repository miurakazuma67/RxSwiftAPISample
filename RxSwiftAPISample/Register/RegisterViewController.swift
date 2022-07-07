//
//  RegisterViewController.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/07.
//

import UIKit

final class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    static func makeFromStoryboard() -> RegisterViewController {
        UIStoryboard(name: "Register", bundle: nil).instantiateInitialViewController() as! RegisterViewController
    }
}
