//
//  LoginViewModel.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/07.
//

import Foundation
import RxSwift
import RxCocoa

//protocol LoginViewModelInput {
//    // メールアドレス 外部から入力を受け取るのでObserver
//    var mailObserver: AnyObserver<String> { get }
//    // パスワード
//    var passwordObserver: AnyObserver<String> { get }
//}
//
//protocol LoginViewModelOutput {
//    var mailValidation: Driver<ValidationResult> { get }
//    var passwordValidation: Driver<ValidationResult> { get }
//    var loginValidation: Driver<Bool> { get }
//}
//
//final class LoginViewModel: LoginViewModelInput, LoginViewModelOutput {
//
//    private let disposeBag = DisposeBag()
//
//    /*Input*/
//    private let _addressObserver = BehaviorRelay<String>(value: "")
//    lazy var mailObserver: AnyObserver<String> = .init { [weak self] event in
//        guard let element = event.element else { return }
//        self?._addressObserver.accept(element)
//    }
//
//    private let _passwordObserver = BehaviorRelay<String>(value: "")
//    lazy var passwordObserver: AnyObserver<String> = .init { [weak self] event in
//        guard let element = event.element else { return }
//        self?._passwordObserver.accept(element)
//    }
//
//    /*Output*/
//    private let _addressValidation = BehaviorRelay<ValidationResult>(value: .empty)
//    lazy var mailValidation: Driver<ValidationResult> = _addressValidation.asDriver(onErrorDriveWith: .empty())
//
//    private let _passwordValidation = BehaviorRelay<ValidationResult>(value: .empty)
//    lazy var passwordValidation: Driver<ValidationResult> = _passwordValidation.asDriver(onErrorDriveWith: .empty())
//
//    lazy var loginValidation: Driver<Bool> = Driver.just(false)
//
//    init() {
//
//        _addressObserver
//            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
//            .flatMapLatest{ address -> Observable<ValidationResult> in
//                Validation.shared.validate(address: address)
//            }.bind(to: _addressValidation).disposed(by: disposeBag)
//
//        _passwordObserver
//            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
//            .flatMapLatest { password -> Observable<ValidationResult> in
//                Validation.shared.validate(password: password)
//            }.bind(to: _passwordValidation).disposed(by: disposeBag)
//
//        loginValidation = Driver.combineLatest(mailValidation, passwordValidation) { address, password in
//            return address.isValid && password.isValid
//        }
//    }
//}
