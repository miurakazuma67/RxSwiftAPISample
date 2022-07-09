//
//  ViewController.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/04.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

final class LoginViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let viewModel = LoginViewModel()
    private lazy var input: LoginViewModelInput = viewModel
    private lazy var output: LoginViewModelOutput = viewModel

    @IBOutlet private weak var addressTextField: UITextField!
    @IBOutlet private weak var addressValidationLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordValidationLabel: UILabel!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }

    private func setupBinding(){
        addressTextField.rx.text.filterNil().bind(to: input.addressObserver).disposed(by: disposeBag)
        passwordTextField.rx.text.filterNil()
            .bind(to: input.passwordObserver).disposed(by: disposeBag)

        output.addressValidation
            .drive(addressValidationLabel.rx.validationText).disposed(by: disposeBag)
        output.passwordValidation
            .drive(passwordValidationLabel.rx.validationText).disposed(by: disposeBag)
        output.loginValidation
            .drive(loginButton.rx.isEnabled).disposed(by: disposeBag)
    }

    @IBAction func registerButtonTapped(_ sender: Any) {
        Router.shared.showRegister(from: self)
    }

}

