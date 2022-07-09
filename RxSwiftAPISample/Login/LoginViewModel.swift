//
//  LoginViewModel.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/07.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginViewModelInput {
    // メールアドレス 外部から入力を受け取るのでObserver
    var addressObserver: AnyObserver<String> { get }
    // パスワード
    var passwordObserver: AnyObserver<String> { get }
}

protocol LoginViewModelOutput {
    var addressValidation: Driver<ValidationText> { get }
    var passwordValidation: Driver<ValidationText> { get }
    var loginValidation: Driver<Bool> { get }
}

final class LoginViewModel: LoginViewModelInput, LoginViewModelOutput {

    private let disposeBag = DisposeBag()

    /*Input*/
    private let _addressObserver = BehaviorRelay<String>(value: "")
    lazy var addressObserver: AnyObserver<String> = .init { [weak self] event in
        guard let e = event.element else { return }
        self?._addressObserver.accept(e)
    }

    private let _passwordObserver = BehaviorRelay<String>(value: "")
    lazy var passwordObserver: AnyObserver<String> = .init { [weak self] event in
        guard let e = event.element else { return }
        self?._passwordObserver.accept(e)
    }

    /*Output*/
    private let _addressValidation = BehaviorRelay<ValidationText>(value: .empty)
    lazy var addressValidation: Driver<ValidationText> = _addressValidation.asDriver(onErrorDriveWith: .empty())

    private let _passwordValidation = BehaviorRelay<ValidationText>(value: .empty)
    lazy var passwordValidation: Driver<ValidationText> = _passwordValidation.asDriver(onErrorDriveWith: .empty())

    lazy var loginValidation: Driver<Bool> = Driver.just(false)

    init() {

        _addressObserver
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest{ id -> Observable<ValidationText> in
                Validation.shared.validate(address: id)
            }.bind(to: _addressValidation).disposed(by: disposeBag)

        _passwordObserver
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { password -> Observable<ValidationText> in
                Validation.shared.validate(password: password)
            }.bind(to: _passwordValidation).disposed(by: disposeBag)

        loginValidation = Driver.combineLatest(addressValidation, passwordValidation){ address, password in
            return address.isValid && password.isValid
        }
    }
}
