//
//  ResisterViewModel.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/07.
//

import Foundation
import RxSwift
import RxCocoa

protocol RegisterViewModelInput {
    // メールアドレス 外部から入力を受け取るのでObserver
    var addressObserver: AnyObserver<String> { get }
    // パスワード
    var passwordObserver: AnyObserver<String> { get }
    // パスワード(確認用)
    var repeatedPasswordObserver: AnyObserver<String> { get }
}

protocol RegisterViewModelOutput {
    var addressValidation: Driver<ValidationResult> { get }
    var passwordValidation: Driver<ValidationResult> { get }
    var repeatedPasswordValidation: Driver<ValidationResult> { get }
    var registerValidation: Driver<Bool> { get }
}

final class RegisterViewModel: RegisterViewModelInput, RegisterViewModelOutput {

    private let disposeBag = DisposeBag()

    /*Input*/
    private let _addressObserver = BehaviorRelay<String>(value: "")
    lazy var addressObserver: AnyObserver<String> = .init { [weak self] event in
        guard let element = event.element else { return }
        self?._addressObserver.accept(element)
    }

    private let _passwordObserver = BehaviorRelay<String>(value: "")
    lazy var passwordObserver: AnyObserver<String> = .init { [weak self] event in
        guard let element = event.element else { return }
        self?._passwordObserver.accept(element)
    }

    private let _repeatedPasswordObserver = BehaviorRelay<String>(value: "")
    lazy var repeatedPasswordObserver: AnyObserver<String> = .init { [weak self] event in
        guard let element = event.element else { return }
        self?._repeatedPasswordObserver.accept(element)
    }

    /*Output*/
    private let _addressValidation = BehaviorRelay<ValidationResult>(value: .empty)
    // Viewで扱いたいからメインスレッド保証したいからDriverで宣言
    lazy var addressValidation: Driver<ValidationResult> = _addressValidation.asDriver(onErrorDriveWith: .empty())

    private let _passwordValidation = BehaviorRelay<ValidationResult>(value: .empty)
    lazy var passwordValidation: Driver<ValidationResult> = _passwordValidation.asDriver(onErrorDriveWith: .empty())

    private let _repeatedPasswordValidation = BehaviorRelay<ValidationResult>(value: .empty)
    lazy var repeatedPasswordValidation: Driver<ValidationResult> = _repeatedPasswordValidation.asDriver(onErrorDriveWith: .empty())

    lazy var registerValidation: Driver<Bool> = Driver.just(false)

    init() {

        _addressObserver
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest{ address -> Observable<ValidationResult> in
                Validation.shared.validate(address: address)
            }.bind(to: _addressValidation).disposed(by: disposeBag)

        _passwordObserver
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { password -> Observable<ValidationResult> in
                Validation.shared.validate(password: password)
            }.bind(to: _passwordValidation).disposed(by: disposeBag)

        //ここはrepeated用のfunc使うはず
        _repeatedPasswordObserver
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { password, repeatedPassword -> Observable<ValidationResult> in
                Validation.shared.validate(password: repeatedPassword)
            }.bind(to: _passwordValidation).disposed(by: disposeBag)

        registerValidation = Driver.combineLatest(addressValidation, passwordValidation) { address, password in
            return address.isValid && password.isValid
        }
    }
}


