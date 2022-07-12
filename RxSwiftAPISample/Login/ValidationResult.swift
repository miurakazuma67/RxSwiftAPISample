//
//  ValidationResult.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/08.
//

import Foundation
import RxSwift
import RxCocoa

enum ValidationResult {
    case ok(message: String)
    case empty
    case failed(message: String)
}

extension ValidationResult {

    var isValid: Bool {
        switch self{
        case .ok: return true
        default: return false
        }
    }
}

final class Validation {

    private init() {}
    static let shared = Validation()

    func validate(address: String) -> Observable<ValidationResult> {

        if address.isEmpty{
            return Observable.just(.empty)
        }

        if address.count < 5{
            return Observable.just(.failed(message: "メールアドレスの文字数が正しくありません"))
        }

        if !address.validateEmail() {
            return Observable.just(.failed(message: "メールアドレスが正しくありません"))
        } else {
            return Observable.just(.ok(message: "OK"))
        }
    }

    func validate(password: String) -> Observable<ValidationResult> {
        if password.isEmpty{
            return Observable.just(.empty)
        }

        if password.count < 8 {
            return Observable.just(.failed(message: "8文字以上入力してください"))
        }

        if !password.isAlphanumeric() {
            return Observable.just(.failed(message: "半角英数以外を入力しないでください"))
        } else {
            return Observable.just(.ok(message: "OK"))
        }
    }

    //パスワード(確認用)に使うメソッド
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> Observable<ValidationResult> {
        if repeatedPassword.isEmpty{
            return Observable.just(.empty)
        }

        if repeatedPassword == password {
            return Observable.just(.ok(message: "OK"))
        }
        else {
            return Observable.just(.failed(message: "パスワードが一致しません"))
        }
    }
}
