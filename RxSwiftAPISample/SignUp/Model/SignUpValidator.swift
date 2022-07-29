//
//  SignUpValidator.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/17.
//

import Foundation
import RxSwift

final class SignUpValidator {
    let minPasswordCount = 8
    let minUsernameCount = 3

    func validateEmail(_ email: String) -> ValidationResult {
        let numberOfCharacters = email.count
        if numberOfCharacters == 0 {
            return .empty(message: "")
        }
        if !email.contains("@") {
            return .failed(message: "メールアドレスが正しくありません")
        }
        return .ok(message: "ok")
    }

    func validateUsername(_ username: String) -> ValidationResult {
        let numberOfCharacters = username.count
        if numberOfCharacters == 0 {
            return .empty(message: "")
        }
        if numberOfCharacters < minUsernameCount {
            return .failed(message: "メールアドレスは\(minUsernameCount)文字以上入力してください")
        }
        return .ok(message: "ok")
    }

    func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters = password.count
        if numberOfCharacters == 0 {
            return .empty(message: "")
        }
        if numberOfCharacters < minPasswordCount {
            return .failed(message: "パスワードは\(minPasswordCount)文字以上入力してください")
        }
        return .ok(message: "ok")
    }

    func validatePasswordConfirm(_ password: String, _ passwordConfirm: String) -> ValidationResult {
        let numberOfCharacters = passwordConfirm.count
        if numberOfCharacters == 0 {
            return .empty(message: "")
        }

        if password != passwordConfirm {
            return .failed(message: "パスワードが正しくありません")
        }
        return .ok(message: "ok")
    }

}
