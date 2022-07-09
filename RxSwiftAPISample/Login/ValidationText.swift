//
//  ValidationText.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/08.
//

import Foundation
import RxSwift
import RxCocoa

enum ValidationText {
    case ok(message: String)
    case empty
    case failed(message: String)
}

extension ValidationText {

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

    func validate(address: String) -> Observable<ValidationText> {

        if address.isEmpty{
            return Observable.just(.empty)
        //文字数が5文字未満だった場合
//        } else if address.count < 5{
//            return Observable.just(.failed(message: "メールアドレスの文字数が正しくありません"))
        //文字列に半角英数以外が入っている場合
        } else if !address.isAlphanumeric(){
            return Observable.just(.failed(message: "メールアドレスが正しくありません"))
        }else{
            return Observable.just(.ok(message: "OK"))
        }
    }

    func validate(password: String) -> Observable<ValidationText> {
        if password.isEmpty{
            return Observable.just(.empty)
        //文字数が8文字未満だった場合
        } else if password.count < 8 {
            return Observable.just(.failed(message: "8文字以上入力してください"))
        //文字列が正しくない場合（半角英数以外が入っている）
        } else if !password.isAlphanumeric() {
            return Observable.just(.failed(message: "半角英数以外を入力しないでください"))
        } else {
            return Observable.just(.ok(message: "OK"))
        }
    }
}
