//
//  ResisterViewModel.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/07.
//

import Foundation
import RxSwift
import RxCocoa

// initで受けとったObservableを処理して出力に変換
// API用のロジックなどをイニシャライザなどで外部から用意できるようにする

final class RegisterViewModel {
    // output
    var addressValidation: Driver<ValidationResult>
    var passwordValidation: Driver<ValidationResult>
    var repeatedPasswordValidation: Driver<ValidationResult>
    var registerValidation: Driver<Bool>

    private let disposeBag = DisposeBag()

    init(input: (
        address: Observable<String>,
        password: Observable<String>,
        repeatedPassword: Observable<String>
    )
    ) {
        // ここでaddress, password, repeatedPasswordに値を流す
    }

    /*Input*/
    private let _addressObserver = BehaviorRelay<String>(value: "")
    lazy var addressObserver: AnyObserver<String> = .init { [weak self] event in
        guard let element = event.element else { return }
        self?._addressObserver.accept(element)
    }

    private let _passwordObserver = BehaviorRelay<String>(value: "")
    var passwordObserver: Driver<String> {
        _passwordObserver.asDriver()
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

        //ここはrepeated用のfunc使う, combineLatest使いたい
        // flatMapLatestは使えないので他でやる
        _repeatedPasswordObserver
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .combineLatest(passwordObserver, repeatedPasswordObserver) { password, repeatedPassword in
                Validation.shared.validateRepeatedPassword(password: password, repeatedPassword: repeatedPassword)
            }.bind(to: _repeatedPasswordValidation).disposed(by: disposeBag)

        registerValidation = Driver.combineLatest(addressValidation, passwordValidation) { address, password in
            return address.isValid && password.isValid
        }
    }
}


