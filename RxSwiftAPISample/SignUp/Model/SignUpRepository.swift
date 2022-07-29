//
//  SignUpDefaultAPI.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/17.
//

import Foundation
import RxSwift
import Firebase
import FirebaseAuth

protocol SignUpRepositoryProtocol {
    func signUp(email: String, password: String, username: String) -> Observable<User>
}

final class SignUpRepository: SignUpRepositoryProtocol {

    func signUp(email: String, password: String, username: String) -> Observable<User> {
        return Observable<User>.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let user = authResult?.user {
                    // usernameをuserに保存する
                    let req = user.createProfileChangeRequest()
                    req.displayName = username
                    req.commitChanges(completion: { (error) in
                        if let error = error {
                            observer.onError(error)
                        } else {
                            observer.onNext(user)
                            observer.onCompleted()
                        }
                    })
                } else if let error = error {
                    observer.onError(error)
                } else {
                    observer.onError(MyError.unknown)
                }
            }
            return Disposables.create()
        }
    }
}
