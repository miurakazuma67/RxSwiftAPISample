//
//  RegisterViewController.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/07.
//

import UIKit

final class RegisterViewController: UIViewController {
    // 1. StoryBoardのUIコンポーネントを繋ぐ
    // 2. VMの初期化
    // 3. VMの出力(output)とUIコンポーネントをbindする
    // 4. その他の処理

    @IBOutlet private weak var mailTextField: UITextField!
    @IBOutlet private weak var mailValidationLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordValidationLabel: UILabel!
    @IBOutlet private weak var repeatedPasswordTextField: UITextField!
    @IBOutlet private weak var repeatedPasswordValidationLabel: UILabel!
    @IBOutlet private weak var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    static func makeFromStoryboard() -> RegisterViewController {
        UIStoryboard(name: "Register", bundle: nil).instantiateInitialViewController() as! RegisterViewController
    }
}
