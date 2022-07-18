//
//  RegisterViewController.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/07.
//

import UIKit
import RxSwift
import RxCocoa
import JGProgressHUD
import FirebaseAuthUI
import FirebaseEmailAuthUI

class SignUpViewController: UIViewController, ProgressHudEnable, ErrorAlertEnable {
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var usernameValidation: UILabel!

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var emailValidation: UILabel!

    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordValidation: UILabel!
    @IBOutlet private weak var passwordConfirmTextField: UITextField!
    @IBOutlet private weak var passwordConfirmValidation: UILabel!

    @IBOutlet private weak var signUpButon: UIButton!
    @IBOutlet private weak var signInUIButton: UIButton!

    let progressHud = JGProgressHUD(style: .dark)

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupUI()
    }

    private func setupBinding() {
        let viewModel = SignUpViewModel(
            input:
            (
                email: emailTextField.rx.text.orEmpty.asDriver(),
                username: usernameTextField.rx.text.orEmpty.asDriver(),
                password: passwordTextField.rx.text.orEmpty.asDriver(),
                passwordConfirm: passwordConfirmTextField.rx.text.orEmpty.asDriver(),
                signUpTaps: signUpButon.rx.tap.asSignal()
            ),
            signUpAPI: SignUpDefaultAPI()
        )

        viewModel.emailValidation
            .drive(emailValidation.rx.validationResult)
            .disposed(by: disposeBag)

        viewModel.usernameValidation
            .drive(usernameValidation.rx.validationResult)
            .disposed(by: disposeBag)

        viewModel.passwordValidation
            .drive(passwordValidation.rx.validationResult)
            .disposed(by: disposeBag)

        viewModel.passwordConfirmValidation
            .drive(passwordConfirmValidation.rx.validationResult)
            .disposed(by: disposeBag)

        viewModel.signUpEnabled
            .drive(onNext: { [weak self] valid  in
                self?.signUpButon.isEnabled = valid
                self?.signUpButon.alpha = valid ? 1.0 : 0.5
            })
            .disposed(by: disposeBag)

        viewModel.signedUp
            .drive(onNext: { _ in
                // サインアップに成功したら入力フィールドをクリア
                self.emailTextField.text = ""
                self.emailTextField.sendActions(for: .valueChanged)
                self.usernameTextField.text = ""
                self.usernameTextField.sendActions(for: .valueChanged)
                self.passwordTextField.text = ""
                self.passwordTextField.sendActions(for: .valueChanged)
                self.passwordConfirmTextField.text = ""
                self.passwordConfirmTextField.sendActions(for: .valueChanged)

                Router.shared.showBase(from: self)
            })
            .disposed(by: disposeBag)

        viewModel.signingUp
            .drive( self.rx.showProgressHud)
            .disposed(by: disposeBag)

        // POST失敗時はアラートを表示する
        viewModel.signUpError
            .drive( self.rx.showErrorAlert )
            .disposed(by: disposeBag)

        // 背景をタップしたらキーボードを隠す
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tapBackground)
    }

    private func setupUI() {
        signInUIButton.addTarget(self, action: #selector(signInUIButtonTapped(any:)), for: .touchUpInside)
    }

    static func makeFromStoryboard()->SignUpViewController {
        UIStoryboard(name: "SignUp", bundle: nil).instantiateInitialViewController() as! SignUpViewController
    }
}

/// ログインはFirebaseUIを利用する
extension SignUpViewController: FUIAuthDelegate {
    @objc func signInUIButtonTapped(any: UIControl) {
        guard let authUI = FUIAuth.defaultAuthUI() else { fatalError("FUIAuth i nil") }

        authUI.delegate = self
        let providers: [FUIAuthProvider] = [
            FUIEmailAuth(authAuthUI: authUI, signInMethod: EmailPasswordAuthSignInMethod, forceSameDevice: false, allowNewEmailAccounts: false, actionCodeSetting: ActionCodeSettings())
        ]
        authUI.providers = providers
        let authViewController = authUI.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }

    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if error == nil {
            Router.shared.showBase(from: self)
        }
    }
}
