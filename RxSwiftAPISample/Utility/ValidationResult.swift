//
//  ValidationResult.swift
//  RxSwiftAPISample
//
//  Created by 三浦　一真 on 2022/07/17.
//

import RxSwift
import RxCocoa

enum MyError: Error {
    case notAuth
    case unknown
}

enum ValidationResult {
    case ok(message: String)
    case empty(message: String)
    case validating
    case failed(message: String)

    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}
